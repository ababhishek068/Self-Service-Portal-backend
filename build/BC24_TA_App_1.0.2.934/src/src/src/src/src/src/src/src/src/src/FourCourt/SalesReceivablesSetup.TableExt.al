tableextension 50042 SalesReceivablesSetup extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Default Customer Posting Group"; code[20])
        {
            TableRelation = "Customer Posting Group".Code;
        }


    }
}