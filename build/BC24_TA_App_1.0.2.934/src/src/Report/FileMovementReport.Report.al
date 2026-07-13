report 50028 "File Movement Report"
{
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Registry Files"; "Registry Files")
        {
            RequestFilterFields = "File No.";

            //Columns in Dataset
            column(CompInfoName; CompInfo.Name) { }

            column(CompInfoPicture; CompInfo.Picture) { }


            column(Date_Created; "Date Created") { }

            column(File_Subject_Description; "File Subject/Description") { }

            column(Recieving_Officer_Name; "Recieving Officer Name") { }

            column(Receiving_Officer_ID; "Receiving Officer ID") { }

            column(Expected_Return_Date; "Expected Return Date") { }


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
                // group(Control3)
                // {
                //     Caption = 'Options';
                //     field(SelectedPeriod; SelectedPeriod)
                //     {
                //         ApplicationArea = Basic;
                //         Caption = 'Payroll Period';
                //         TableRelation = "PR Payroll Periods"."Date Opened";
                //     }
                //     field(EmpNo; EmpNo)
                //     {
                //         ApplicationArea = Basic;
                //         Caption = 'Employee No.';
                //         TableRelation = "PR Payroll Periods"."Date Opened";
                //     }
                // }
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