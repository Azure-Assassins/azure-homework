bash# Part 1: Region Restriction Policy
az deployment mg create \
  --name "region-restriction" \
  --location eastus \
  --management-group-id "Finance-NonProd" \
  --template-file assign-region.bicep

# Move subscription to Finance-NonProd
az account management-group subscription add \
  --name "Finance-NonProd" \
  --subscription "34e338c5-1413-4da2-90b9-93baa6d8a412"

# Test - Try to create resource in westus (should fail)
az storage account create \
  --name "teststorage1768506520" \
  --resource-group "finance-test-rg" \
  --location "westus" \
  --sku "Standard_LRS"

# Part 2: Auto-Remediation Policy
az deployment mg create \
  --name "auto-tag-policy" \
  --location eastus \
  --management-group-id "Finance-NonProd" \
  --template-file modify-tag.bicep

# Test - Create resource without tags
az storage account create \
  --name "autotagtestfinance" \
  --resource-group "finance-test-rg" \
  --location "eastus" \
  --sku "Standard_LRS"

# Verify auto-added tag
az storage account show \
  --name "autotagtestfinance" \
  --resource-group "finance-test-rg" \
  --query "tags"
```

---