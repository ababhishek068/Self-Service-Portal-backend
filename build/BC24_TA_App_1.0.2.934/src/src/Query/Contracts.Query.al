query 50024 Contracts
{

    elements
    {
        dataitem(Contract; Contract)
        {
            column(Contract_No_; "Contract No.") { }
            column(Contract_Reference_No; "Contract Reference No") { }
            column(Contract_Status; "Contract Status") { }
            column(Contract_Type; "Contract Type") { }
            column(Contract_Value; "Contract Value") { }
            column(Contractor_No_; "Contractor No.") { }
            column(Expiry_Date; "Expiry Date") { }
            column(Status; Status) { }
            column(Subject_Matter; "Subject Matter") { }
            column(Remarks_Section; "Remarks Section") { }
            column(Duration; Duration) { }
            column(Milestone_Amount; "Milestone Amount") { }

            column(Milestone_Balance; "Milestone Balance") { }
            column(Paid_Milestone; "Paid Milestone") { }
            column(Unpaid_Milestone; "Unpaid Milestone") { }
        }
    }
}

