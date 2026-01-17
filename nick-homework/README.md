Homework for Azure Week 1

### How to run 


```
az deployment mg create \
  --name "finance-region-lock" \
  --location eastus \
  --management-group-id "Finance-NonProd" \
  --template-file azure-assign-region.bicep

az deployment mg create \
  --name "finance-auto-tag" \
  --location eastus \
  --management-group-id "Finance-NonProd" \
  --template-file azure-modify-tag.bicep
```

### How to test

#### Create storage account in UK South (should fail)
```
az storage account create \
  --name "storageaccfinance2" \
  --resource-group "finance-test-storage-rg" \
  --location "uksouth" \
  --sku "Standard_LRS"
  ```

#### Create untagged storage account in East US

az storage account create \
  --name "testfinancemodifytag" \
  --resource-group "finance-test-storage-rg" \
  --location "eastus" \
  --sku "Standard_LRS"

#### Verify tag department : finance has been appended to untagged storage account

az storage account show \
  --name "testfinancemodifytag" \
  --resource-group "finance-test-storage-rg" \
  --query "tags"
```

