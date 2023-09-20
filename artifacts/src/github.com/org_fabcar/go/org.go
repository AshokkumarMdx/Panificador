package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"strconv"
	"time"

	"github.com/hyperledger/fabric-chaincode-go/pkg/cid"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	"github.com/hyperledger/fabric/common/flogging"
)

type SmartContract struct {
	contractapi.Contract
}

var logger = flogging.MustGetLogger("orgtewt12_cc")

type Org struct {
	ID      string `json:"id"`
	Make    string `json:"make"`
	Model   string `json:"model"`
	Color   string `json:"color"`
	Owner   string `json:"owner"`
	AddedAt uint64 `json:"addedAt"`
}

func (s *SmartContract) CreateOrg(ctx contractapi.TransactionContextInterface, orgData string) (string, error) {

	if len(orgData) == 0 {
		return "", fmt.Errorf("Please pass the correct org data")
	}

	var org Org
	err := json.Unmarshal([]byte(orgData), &org)
	if err != nil {
		return "", fmt.Errorf("Failed while unmarshling org. %s", err.Error())
	}

	orgAsBytes, err := json.Marshal(org)
	if err != nil {
		return "", fmt.Errorf("Failed while marshling org. %s", err.Error())
	}

	ctx.GetStub().SetEvent("CreateAsset", orgAsBytes)

	return ctx.GetStub().GetTxID(), ctx.GetStub().PutState(org.ID, orgAsBytes)
}

func (s *SmartContract) ABACTest(ctx contractapi.TransactionContextInterface, orgData string) (string, error) {

	mspId, err := cid.GetMSPID(ctx.GetStub())
	if err != nil {
		return "", fmt.Errorf("failed while getting identity. %s", err.Error())
	}
	if mspId != "Org2MSP" {
		return "", fmt.Errorf("You are not authorized to create Org Data")
	}

	if len(orgData) == 0 {
		return "", fmt.Errorf("Please pass the correct org data")
	}

	var org Org
	err = json.Unmarshal([]byte(orgData), &org)
	if err != nil {
		return "", fmt.Errorf("Failed while unmarshling org. %s", err.Error())
	}

	orgAsBytes, err := json.Marshal(org)
	if err != nil {
		return "", fmt.Errorf("Failed while marshling org. %s", err.Error())
	}

	ctx.GetStub().SetEvent("CreateAsset", orgAsBytes)

	return ctx.GetStub().GetTxID(), ctx.GetStub().PutState(org.ID, orgAsBytes)
}

func (s *SmartContract) CreatePrivateDataImplicitForOrg1(ctx contractapi.TransactionContextInterface, orgData string) (string, error) {

	if len(orgData) == 0 {
		return "", fmt.Errorf("please pass the correct document data")
	}

	var org Org
	err := json.Unmarshal([]byte(orgData), &org)
	if err != nil {
		return "", fmt.Errorf("failed while un-marshalling document. %s", err.Error())
	}

	orgAsBytes, err := json.Marshal(org)
	if err != nil {
		return "", fmt.Errorf("failed while marshalling org. %s", err.Error())
	}

	return ctx.GetStub().GetTxID(), ctx.GetStub().PutPrivateData("_implicit_org_Org1MSP", org.ID, orgAsBytes)
}

//
func (s *SmartContract) UpdateOrgOwner(ctx contractapi.TransactionContextInterface, orgID string, newOwner string) (string, error) {

	if len(orgID) == 0 {
		return "", fmt.Errorf("Please pass the correct org id")
	}

	orgAsBytes, err := ctx.GetStub().GetState(orgID)

	if err != nil {
		return "", fmt.Errorf("Failed to get org data. %s", err.Error())
	}

	if orgAsBytes == nil {
		return "", fmt.Errorf("%s does not exist", orgID)
	}

	org := new(Org)
	_ = json.Unmarshal(orgAsBytes, org)

	org.Owner = newOwner

	orgAsBytes, err = json.Marshal(org)
	if err != nil {
		return "", fmt.Errorf("Failed while marshling org. %s", err.Error())
	}

	//  txId := ctx.GetStub().GetTxID()

	return ctx.GetStub().GetTxID(), ctx.GetStub().PutState(org.ID, orgAsBytes)

}

func (s *SmartContract) GetHistoryForAsset(ctx contractapi.TransactionContextInterface, orgID string) (string, error) {

	resultsIterator, err := ctx.GetStub().GetHistoryForKey(orgID)
	if err != nil {
		return "", fmt.Errorf(err.Error())
	}
	defer resultsIterator.Close()

	var buffer bytes.Buffer
	buffer.WriteString("[")

	bArrayMemberAlreadyWritten := false
	for resultsIterator.HasNext() {
		response, err := resultsIterator.Next()
		if err != nil {
			return "", fmt.Errorf(err.Error())
		}
		if bArrayMemberAlreadyWritten == true {
			buffer.WriteString(",")
		}
		buffer.WriteString("{\"TxId\":")
		buffer.WriteString("\"")
		buffer.WriteString(response.TxId)
		buffer.WriteString("\"")

		buffer.WriteString(", \"Value\":")
		if response.IsDelete {
			buffer.WriteString("null")
		} else {
			buffer.WriteString(string(response.Value))
		}

		buffer.WriteString(", \"Timestamp\":")
		buffer.WriteString("\"")
		buffer.WriteString(time.Unix(response.Timestamp.Seconds, int64(response.Timestamp.Nanos)).String())
		buffer.WriteString("\"")

		buffer.WriteString(", \"IsDelete\":")
		buffer.WriteString("\"")
		buffer.WriteString(strconv.FormatBool(response.IsDelete))
		buffer.WriteString("\"")

		buffer.WriteString("}")
		bArrayMemberAlreadyWritten = true
	}
	buffer.WriteString("]")

	return string(buffer.Bytes()), nil
}

func (s *SmartContract) GetOrgById(ctx contractapi.TransactionContextInterface, orgID string) (*Org, error) {
	if len(orgID) == 0 {
		return nil, fmt.Errorf("Please provide correct contract Id")
		// return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	orgAsBytes, err := ctx.GetStub().GetState(orgID)

	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state. %s", err.Error())
	}

	if orgAsBytes == nil {
		return nil, fmt.Errorf("%s does not exist", orgID)
	}

	org := new(Org)
	_ = json.Unmarshal(orgAsBytes, org)

	return org, nil

}

func (s *SmartContract) DeleteOrgById(ctx contractapi.TransactionContextInterface, orgID string) (string, error) {
	if len(orgID) == 0 {
		return "", fmt.Errorf("Please provide correct contract Id")
	}

	return ctx.GetStub().GetTxID(), ctx.GetStub().DelState(orgID)
}

func (s *SmartContract) GetContractsForQuery(ctx contractapi.TransactionContextInterface, queryString string) ([]Org, error) {

	queryResults, err := s.getQueryResultForQueryString(ctx, queryString)

	if err != nil {
		return nil, fmt.Errorf("Failed to read from ----world state. %s", err.Error())
	}

	return queryResults, nil

}

func (s *SmartContract) getQueryResultForQueryString(ctx contractapi.TransactionContextInterface, queryString string) ([]Org, error) {

	resultsIterator, err := ctx.GetStub().GetQueryResult(queryString)
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	results := []Org{}

	for resultsIterator.HasNext() {
		response, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}

		newOrg := new(Org)

		err = json.Unmarshal(response.Value, newOrg)
		if err != nil {
			return nil, err
		}

		results = append(results, *newOrg)
	}
	return results, nil
}

func (s *SmartContract) GetDocumentUsingOrgContract(ctx contractapi.TransactionContextInterface, documentID string) (string, error) {
	if len(documentID) == 0 {
		return "", fmt.Errorf("Please provide correct contract Id")
	}

	params := []string{"GetDocumentById", documentID}
	queryArgs := make([][]byte, len(params))
	for i, arg := range params {
		queryArgs[i] = []byte(arg)
	}

	response := ctx.GetStub().InvokeChaincode("document_cc", queryArgs, "mychannel")

	return string(response.Payload), nil

}

func (s *SmartContract) CreateDocumentUsingOrgContract(ctx contractapi.TransactionContextInterface, functionName string, documentData string) (string, error) {
	if len(documentData) == 0 {
		return "", fmt.Errorf("Please provide correct document data")
	}

	params := []string{functionName, documentData}
	queryArgs := make([][]byte, len(params))
	for i, arg := range params {
		queryArgs[i] = []byte(arg)
	}

	response := ctx.GetStub().InvokeChaincode("document_cc", queryArgs, "mychannel")

	return string(response.Payload), nil

}

func main() {

	chaincode, err := contractapi.NewChaincode(new(SmartContract))
	if err != nil {
		fmt.Printf("Error create faborg chaincode: %s", err.Error())
		return
	}
	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error starting chaincodes: %s", err.Error())
	}

}
