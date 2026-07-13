report 50108 "Ticket Status"
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("ICT General Requisition Header"; "ICT General Requisition Header")
        {
            RequestFilterFields = "No";

            //Columns in Dataset
            column(CompInfoName; CompInfo.Name) { }

            column(CompInfoPicture; CompInfo.Picture) { }

            column(No; No) { }

            column(Date; Date) { }

            column(Requisition_Category; "Requisition Category") { }
            column(Global_Dimension_1_Code; "Global Dimension 1 Code") { }

            column(Global_Dimension_2_Code; "Global Dimension 2 Code") { }

            column(General_Description; "General Description") { }
            column(Urgency_Priority; "Urgency Priority") { }

            column(Required_Date; "Required Date") { }

            column(Resolution_Status; "Resolution Status") { }

            //Data Item Report triggers
            trigger OnPreDataItem()
            begin
            end;

            trigger OnAfterGetRecord()
            begin
            end;

            trigger OnPostDataItem()
            begin

            end;
        }

    }


    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Control3) { }
            }
        }
    }

    //Global Variables
    var

        CompInfo: Record "Company Information";

    //Global Procedures


    //Report Triggers
    trigger OnInitReport()
    begin
    end;

    trigger OnPreReport()
    begin
        CompInfo.Reset;
        CompInfo.Get;
        CompInfo.CalcFields(Picture);
    end;

    trigger OnPostReport()
    begin
    end;
}