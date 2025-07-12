**Azure Cost Optimization: Serverless Billing Records Archival Solution**

📘 **Problem Statement**

We have a serverless architecture where billing records are stored in Azure Cosmos DB. With over 2 million records and each up to 300 KB in size, storage costs have significantly increased. Records older than 3 months are rarely accessed but must remain available with a response time in seconds.

---

✅ **High-Level Solution Overview**

We'll introduce a tiered storage strategy:

- Keep recent (≤3 months) billing records in Azure Cosmos DB.
- Move older (>3 months) billing records to Azure Blob Storage in compressed JSON or Parquet format.
- Implement a Durable Azure Function that:
  - Periodically archives old records.
  - Handles smart retrieval: serves from Cosmos DB first, then Blob if not found.
- Expose same APIs through a Smart Fallback Layer to ensure backward compatibility.

---

🧠 Smart Retrieval Logic (Fallback API)
Read from Cosmos DB → if not found → read from Blob → (optional) cache in Cosmos DB.

---

✅ **Benefits**
- No API changes.
- Seamless fallback.
- Efficient cost reduction.

---

**📂 Folder Structure**

```
modules/                  # Terraform scripts
function-app/           # Durable Function logic
api/                    # Fallback API (FastAPI)
tests/                  # Integration tests
.github/workflows/      # CI/CD pipeline
```
---

**🚀 Setup**

1. **Deploy Infrastructure**

```bash
cd infra/
terraform init
terraform plan
terraform apply 
```
---

🧾 **Core Components & Details**

1. **Archival Logic (Durable Function)**

Triggered by a TimerTrigger (e.g., daily).
Steps:
- Query Cosmos DB for records older than 3 months.
- Serialize and compress the records (e.g., GZIP+JSON or Parquet).
- Upload to Azure Blob Storage (container = billing-archive/yyyy-mm).
- Delete the archived records from Cosmos DB.

## Pseudocode for archival

```
for record in cosmos_db.query("SELECT * FROM Billing WHERE _ts < three_months_ago"):
    blob_name = f"{record['customerId']}/{record['invoiceId']}.json.gz"
    compressed = gzip_compress(json.dumps(record))
    blob_storage.upload(blob_name, compressed)
    cosmos_db.delete(record['id'])
```
    
2. **Retrieval Logic (Smart Fallback API)**

A proxy layer within the existing billing service.

## Pseudocose for retrieval:
```
def get_billing_record(id):
    result = cosmos_db.read(id)
    if result:
        return result
    else:
        blob = blob_storage.get(f"{customer_id}/{invoice_id}.json.gz")
        return json.loads(gzip_decompress(blob))
 ```       
Write Path:       
Unchanged — writes still go to Cosmos DB.

---

📉 **Cost Optimization Strategies**

This architecture helps reduce Cosmos DB costs without sacrificing performance or availability:

1. **Cold Data Archival to Blob Storage**  
   Move old data to Blob (cold tier) to minimize Cosmos storage cost.

2. **Dynamic RU Usage Optimization**  
   Fewer records in Cosmos = less RU cost per query.

3. **GZIP Compression**  
   Reduces record size in Blob by up to 80%, lowering storage cost.

4. **Durable Function = Pay-Per-Use**  
   Serverless: only pays per execution, no idle charge.

5. **Read Optimization via Smart Fallback**  
   Blob read cost only incurred when archived data is explicitly accessed.

6. **No API Rewrite**  
   Preserves current client apps; no migration or redeployment needed.

**Optional:** Use Cosmos TTL, Blob lifecycle rules, or index tuning for further cost control.


---

⚠️ **Edge Cases & Mitigation**

| **Potential Issue**                   | **Mitigation Strategy**                                                     |
| ------------------------------------- | --------------------------------------------------------------------------- |
| **Partial Failure in Archival**       | Use **Durable Functions with retry policies**. Log to App Insights.         |
| **Blob Retrieval Latency > 2s**       | Cache frequently accessed old records back to Cosmos DB ("lazy hydration"). |
| **Data Consistency During Migration** | Use ETag/versioning on Cosmos DB. Use transaction batch when deleting.      |
| **Blob Access Failure**               | Use retry + fallback circuit breaker. Alert if persistent.                  |
| **Data Schema Evolution**             | Include schema version in metadata when writing to blob.                    |
| **Billing API Spike on Cold Data**    | Use Azure CDN with Blob Storage if archived data is frequently accessed.    |

---

🔒 **Security Considerations**
- Use Managed Identity for Durable Function to access Blob.
- Configure RBAC and Private Endpoints for secure storage access.
- Enable Soft Delete for both Cosmos and Blob to prevent accidental loss.

---

🔄 **CI/CD & Automation**
- Deploy Durable Function via Azure DevOps or GitHub Actions.
- Set up automated tests to validate retrieval.
- Monitor archival activity with App Insights and custom logs.

---

📊 **Monitoring & Alerting**

Use Application Insights to:
- Track archival job success/failure
- Monitor fallback read % from Blob
- Alert if read latency exceeds SLA (e.g., 3s)
- Dashboard:
  - Daily records archived
  - Total cold storage usage
  - % of fallback reads
 
## AI Assistance Acknowledgement

This solution was co-developed using CHATGPT as a collaborative assistant. The conversation history is added in chatgpt-history.md for your reference.



