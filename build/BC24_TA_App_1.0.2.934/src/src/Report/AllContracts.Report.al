report 50105 "All Contracts"
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Vendor; Vendor)
        {

            RequestFilterFields = "No.";


            column(Companyinfo_Picture; Companyinfo.Picture) { }

            column(CompanyName; Companyinfo.Name) { }

            column(CompanyAddress; Companyinfo.Address) { }

            column(CompanyAddress2; Companyinfo."Address 2") { }

            column(No_; "No.") { }
            column(Name; Name) { }

            column(Contact; Contact) { }

            column(Gender; Gender) { }

            column(Agpo_Category; "Agpo Category") { }

            column(Agpo_Cert__Date; "Agpo Cert. Date") { }

            column(AGPO_No; "AGPO No") { }
            dataitem("Purchase Header"; "Purchase Header")
            {
                DataItemLink = "Buy-from Vendor No." = FIELD("No.");
                RequestFilterFields = "Document Date", "Document Type";
                column(Openning_and_Closing_Date; "Openning and Closing Date") { }

                column(Evaluation_Date; "Evaluation Date") { }

                column(Notification_Award_Date; "Notification Award Date") { }

                column(Opinion_No; "Opinion No") { }

                column(VAT_Registration_No_; "VAT Registration No.") { }

                column(Department; Department) { }
                column(Department_Name; "Department Name") { }
                column(PurchHeaderDocNo_; "No.") { }

                column(Buy_from_Vendor_No_; "Buy-from Vendor No.") { }
                column(Buy_from_Vendor_Name; "Buy-from Vendor Name") { }
                column(Procurement_Method; "Procurement Method") { }

                column(Scheme_Applied; "Scheme Applied") { }

                column(Posting_Description; "Posting Description") { }

                column(Nature_of_Contract; "Nature of Contract") { }

                column(LPO_No_; "LPO No.") { }

                column(Amount; Amount) { }

                column(Amount_Including_VAT; "Amount Including VAT") { }

                column(Tender_Award_Date; "Tender Award Date") { }


                column(Tender_Category; "Tender Category") { }

                column(Tendor_Number; "Tendor Number") { }


                column(Contract; Contract) { }

                column(Contract_Completion_Date; "Contract Completion Date") { }

                column(Date_of_Contract; "Date of Contract") { }
            }
            dataitem(ContractRec; Contract)
            {
                DataItemLink = "Contractor No." = field("No.");
                column(Contract_No_; "Contract No.") { }
                column(Contract_Reference_No; "Contract Reference No") { }
                column(Contract_Status; "Contract Status") { }
                column(Contract_Type; "Contract Type") { }
                column(Contract_Value; "Contract Value") { }
                column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }
                column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code") { }
                column(Shortcut_Dimension_3_Code; "Shortcut Dimension 3 Code") { }
                column(Shortcut_Dimension_4_Code; "Shortcut Dimension 4 Code") { }
                column(Effective_Date; "Effective Date") { }
                column(Expiry_Date; "Expiry Date") { }
                column(Requested_By; "Requested By") { }
                column(Recommendation; Recommendation) { }
                column(Duration; Duration) { }
                column(Milestone_Amount; "Milestone Amount") { }
                column(Milestone_Balance; "Milestone Balance") { }
                column(Paid_Milestone; "Paid Milestone") { }
                column(Unpaid_Milestone; "Unpaid Milestone") { }
                column(Procurement_Method_contract; "Procurement Method") { }
                column(Procurement_WorkPlan; "Procurement WorkPlan") { }
            }

        }


    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName) { }
            }
        }

    }
    var
        CompanyInfo: record "Company Information";

    trigger OnPreReport()
    begin
        CompanyInfo.reset;
        CompanyInfo.get;
        CompanyInfo.CalcFields(Picture);
    end;

}
