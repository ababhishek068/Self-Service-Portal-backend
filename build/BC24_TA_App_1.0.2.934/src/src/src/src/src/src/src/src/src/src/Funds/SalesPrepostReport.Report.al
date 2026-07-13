Report 50263 "Sales Prepost Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ExternalBufferReport.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("External Buffer"; "External Buffer")
        {
            column(Entry_No; "Entry No") { }
            column(Document_No; "Document No") { }
            column(Date; Date) { }
            column(Item_No; "Item No") { }
            column(Description; Description) { }
            column(Customer_No; "Customer No") { }
            column(Bank_No; "Bank No") { }
            column(Quantity; Quantity) { }
            column(Unit_Amount; "Unit Amount") { }
            column(Total_Amount; "Total Amount") { }
            column(Discount_Amount; "Discount Amount") { }
            column(Posted; Posted) { }
            column(Posting_Date; "Posting Date") { }
            column(Posted_By; "Posted By") { }
            column(Station_Code; "Station Code") { }
            column(Payment_Mode; "Payment Mode") { }
            column(Type; Type) { }
            column(Attendant; Attendant) { }

            column(CompName; CompanyInfo.Name) { }
            column(CompPic; CompanyInfo.Picture) { }


            trigger OnAfterGetRecord()
            begin

            end;

            trigger OnPreDataItem()
            begin
                if CompanyInfo.Get() then
                    CompanyInfo.CalcFields(CompanyInfo.Picture);
            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    var

        CompanyInfo: Record "Company Information";

}

