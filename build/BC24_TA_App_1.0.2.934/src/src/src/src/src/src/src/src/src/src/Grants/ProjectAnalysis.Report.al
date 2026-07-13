Report 50130 "Project Analysis"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ProjectAnalysis.rdlc';
    Caption = 'Job Analysis';
    ApplicationArea = All;

    dataset
    {
        dataitem(Jobs; Jobs)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Posting Date Filter", "Planning Date Filter";
            column(ReportForNavId_8019; 8019) { }
            column(TodayFormatted; Format(Today, 0, 4)) { }
            column(CompanyName; COMPANYNAME) { }
            column(JobtableCaptJobFilter; TableCaption + ': ' + JobFilter) { }
            column(JobFilter; JobFilter) { }

            column(JobTaskFilter; JobTaskFilter) { }
            column(No_Job; "No.") { }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl) { }
            column(JobAnalysisCapt; JobAnalysisCaptLbl) { }
            dataitem("Job-Task"; "Job-Task")
            {
                DataItemLink = "Grant No." = field("No.");
                DataItemTableView = sorting("Grant No.", "Grant Task No.");
                RequestFilterFields = "Grant Task No.";
                column(ReportForNavId_2969; 2969) { }
                column(HeadLineText8; HeadLineText[8]) { }
                column(HeadLineText7; HeadLineText[7]) { }
                column(HeadLineText6; HeadLineText[6]) { }
                column(HeadLineText5; HeadLineText[5]) { }
                column(HeadLineText4; HeadLineText[4]) { }
                column(HeadLineText3; HeadLineText[3]) { }
                column(HeadLineText2; HeadLineText[2]) { }
                column(HeadLineText1; HeadLineText[1]) { }
                column(Description_Job; Jobs.Description) { }
                column(DescriptionCaption; DescriptionCaptionLbl) { }
                column(JobTaskNoCapt; JobTaskNoCaptLbl) { }
                dataitem(BlankLine; "Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(ReportForNavId_7860; 7860) { }

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 1, "Job-Task"."No. of Blank Lines");
                    end;
                }
                dataitem("Integer"; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(ReportForNavId_5444; 5444) { }
                    column(JobTaskNo_JobTask; "Job-Task"."Grant Task No.") { }
                    column(Indentation_JobTask; PadStr('', 2 * "Job-Task".Indentation) + "Job-Task".Description) { }
                    column(ShowIntBody1; "Job-Task"."Grant Task Type" in ["Job-Task"."grant task type"::Heading, "Job-Task"."grant task type"::"Begin-Total"]) { }
                    column(Amt1; Amt[1]) { }
                    column(Amt2; Amt[2]) { }
                    column(Amt3; Amt[3]) { }
                    column(Amt4; Amt[4]) { }
                    column(Amt5; Amt[5]) { }
                    column(Amt6; Amt[6]) { }
                    column(Amt7; Amt[7]) { }
                    column(Amt8; Amt[8]) { }
                    column(ShowIntBody2; "Job-Task"."Grant Task Type" in ["Job-Task"."grant task type"::Total, "Job-Task"."grant task type"::"End-Total"]) { }
                    column(ShowIntBody3; ("Job-Task"."Grant Task Type" in ["Job-Task"."grant task type"::Posting]) and PrintSection) { }

                    trigger OnAfterGetRecord()
                    begin
                        PrintSection := true;
                        if ExcludeJobTask then begin
                            PrintSection := false;
                            for I := 1 to 8 do
                                if (Amt[I] <> 0) and (AmountField[I] <> AmountField[I] ::" ") then
                                    PrintSection := true;
                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    //  Clear(JobCalcStatistics);
                    //JobCalcStatistics.ReportAnalysis(Jobs,"Job-Task",Amt,AmountField,CurrencyField,FALSE);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //JobCalcStatistics.GetHeadLineText(AmountField,CurrencyField,HeadLineText,Jobs);
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
                group(Options)
                {
                    Caption = 'Options';
                    field(Control1; AmountField[1])
                    {
                        ApplicationArea = Basic;
                        Caption = 'Amount Field 1 ';
                        OptionCaption = ' ,Schedule Price,Usage Price,Contract Price,Invoiced Price,Schedule Cost,Usage Cost,Contract Cost,Invoiced Cost,Schedule Profit,Usage Profit,Contract Profit,Invoiced Profit';
                        ToolTip = 'Specifies the value of the Amount Field 1  field.';
                    }
                    field(Control5; CurrencyField[1])
                    {
                        ApplicationArea = Basic;
                        Caption = 'Currency Field 1';
                        OptionCaption = 'Local Currency,Foreign Currency';
                        ToolTip = 'Specifies the value of the Currency Field 1 field.';
                    }
                    field(Control3; AmountField[2])
                    {
                        ApplicationArea = Basic;
                        Caption = 'Amount Field 2';
                        OptionCaption = ' ,Schedule Price,Usage Price,Contract Price,Invoiced Price,Schedule Cost,Usage Cost,Contract Cost,Invoiced Cost,Schedule Profit,Usage Profit,Contract Profit,Invoiced Profit';
                        ToolTip = 'Specifies the value of the Amount Field 2 field.';
                    }
                    field(Control8; CurrencyField[2])
                    {
                        ApplicationArea = Basic;
                        Caption = 'Currency Field 2';
                        OptionCaption = 'Local Currency,Foreign Currency';
                        ToolTip = 'Specifies the value of the Currency Field 2 field.';
                    }
                    field(Control9; AmountField[3])
                    {
                        ApplicationArea = Basic;
                        Caption = 'Amount Field 3';
                        OptionCaption = ' ,Schedule Price,Usage Price,Contract Price,Invoiced Price,Schedule Cost,Usage Cost,Contract Cost,Invoiced Cost,Schedule Profit,Usage Profit,Contract Profit,Invoiced Profit';
                        ToolTip = 'Specifies the value of the Amount Field 3 field.';
                    }
                    field(CurrencyField3; CurrencyField[3])
                    {
                        ApplicationArea = Basic;
                        Caption = 'Currency Field 1';
                        OptionCaption = 'Local Currency,Foreign Currency';
                        ToolTip = 'Specifies the value of the Currency Field 1 field.';
                    }
                    field(Control10; AmountField[4])
                    {
                        ApplicationArea = Basic;
                        Caption = 'Amount Field 4';
                        OptionCaption = ' ,Schedule Price,Usage Price,Contract Price,Invoiced Price,Schedule Cost,Usage Cost,Contract Cost,Invoiced Cost,Schedule Profit,Usage Profit,Contract Profit,Invoiced Profit';
                        ToolTip = 'Specifies the value of the Amount Field 4 field.';
                    }
                    field(CurrencyField4; CurrencyField[4])
                    {
                        ApplicationArea = Basic;
                        Caption = 'Currency Field 2';
                        OptionCaption = 'Local Currency,Foreign Currency';
                        ToolTip = 'Specifies the value of the Currency Field 2 field.';
                    }
                    field(Control17; AmountField[5])
                    {
                        ApplicationArea = Basic;
                        Caption = 'Amount Field 5';
                        OptionCaption = ' ,Schedule Price,Usage Price,Contract Price,Invoiced Price,Schedule Cost,Usage Cost,Contract Cost,Invoiced Cost,Schedule Profit,Usage Profit,Contract Profit,Invoiced Profit';
                        ToolTip = 'Specifies the value of the Amount Field 5 field.';
                    }
                    field(CurrencyField5; CurrencyField[5])
                    {
                        ApplicationArea = Basic;
                        Caption = 'Currency Field 1';
                        OptionCaption = 'Local Currency,Foreign Currency';
                        ToolTip = 'Specifies the value of the Currency Field 1 field.';
                    }
                    field(Control18; AmountField[6])
                    {
                        ApplicationArea = Basic;
                        Caption = 'Amount Field 6';
                        OptionCaption = ' ,Schedule Price,Usage Price,Contract Price,Invoiced Price,Schedule Cost,Usage Cost,Contract Cost,Invoiced Cost,Schedule Profit,Usage Profit,Contract Profit,Invoiced Profit';
                        ToolTip = 'Specifies the value of the Amount Field 6 field.';
                    }
                    field(CurrencyField6; CurrencyField[6])
                    {
                        ApplicationArea = Basic;
                        Caption = 'Currency Field 2';
                        OptionCaption = 'Local Currency,Foreign Currency';
                        ToolTip = 'Specifies the value of the Currency Field 2 field.';
                    }
                    field(Control19; AmountField[7])
                    {
                        ApplicationArea = Basic;
                        Caption = 'Amount Field 7';
                        OptionCaption = ' ,Schedule Price,Usage Price,Contract Price,Invoiced Price,Schedule Cost,Usage Cost,Contract Cost,Invoiced Cost,Schedule Profit,Usage Profit,Contract Profit,Invoiced Profit';
                        ToolTip = 'Specifies the value of the Amount Field 7 field.';
                    }
                    field(CurrencyField7; CurrencyField[7])
                    {
                        ApplicationArea = Basic;
                        Caption = 'Currency Field 1';
                        OptionCaption = 'Local Currency,Foreign Currency';
                        ToolTip = 'Specifies the value of the Currency Field 1 field.';
                    }
                    field(Control20; AmountField[8])
                    {
                        ApplicationArea = Basic;
                        Caption = 'Amount Field 8';
                        OptionCaption = ' ,Schedule Price,Usage Price,Contract Price,Invoiced Price,Schedule Cost,Usage Cost,Contract Cost,Invoiced Cost,Schedule Profit,Usage Profit,Contract Profit,Invoiced Profit';
                        ToolTip = 'Specifies the value of the Amount Field 8 field.';
                    }
                    field(CurrencyField8; CurrencyField[8])
                    {
                        ApplicationArea = Basic;
                        Caption = 'Currency Field 2';
                        OptionCaption = 'Local Currency,Foreign Currency';
                        ToolTip = 'Specifies the value of the Currency Field 2 field.';
                    }
                    field(ExcludeJobTask; ExcludeJobTask)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Exclude Zero-Lines';
                        MultiLine = true;
                        ToolTip = 'Specifies the value of the Exclude Zero-Lines field.';
                    }
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        JobFilter := Jobs.GetFilters;
        JobTaskFilter := "Job-Task".GetFilters;
    end;

    var
        // JobCalcStatistics: Codeunit UnknownCodeunit39003907;
        HeadLineText: array[8] of Text[50];
        Amt: array[8] of Decimal;
        AmountField: array[8] of Option " ","Schedule Price","Usage Price","Contract Price","Invoiced Price","Schedule Cost","Usage Cost","Contract Cost","Invoiced Cost","Schedule Profit","Usage Profit","Contract Profit","Invoiced Profit";
        CurrencyField: array[8] of Option "Local Currency","Foreign Currency";
        JobFilter: Text;
        JobTaskFilter: Text;
        ExcludeJobTask: Boolean;
        PrintSection: Boolean;
        I: Integer;
        CurrReportPageNoCaptionLbl: label 'Page';
        JobAnalysisCaptLbl: label 'Job Analysis';
        DescriptionCaptionLbl: label 'Description';
        JobTaskNoCaptLbl: label 'Job Task No.';

    procedure InitializeRequest(NewAmountField: array[8] of Option " ","Schedule Price","Usage Price","Contract Price","Invoiced Price","Schedule Cost","Usage Cost","Contract Cost","Invoiced Cost","Schedule Profit","Usage Profit","Contract Profit","Invoiced Profit"; NewCurrencyField: array[8] of Option "Local Currency","Foreign Currency"; NewExcludeJobTask: Boolean)
    begin
        AmountField[1] := NewAmountField[1];
        CurrencyField[1] := NewCurrencyField[1];
        AmountField[2] := NewAmountField[2];
        CurrencyField[2] := NewCurrencyField[2];
        AmountField[3] := NewAmountField[3];
        CurrencyField[3] := NewCurrencyField[3];
        AmountField[4] := NewAmountField[4];
        CurrencyField[4] := NewCurrencyField[4];
        AmountField[5] := NewAmountField[5];
        CurrencyField[5] := NewCurrencyField[5];
        AmountField[6] := NewAmountField[6];
        CurrencyField[6] := NewCurrencyField[6];
        AmountField[7] := NewAmountField[7];
        CurrencyField[7] := NewCurrencyField[7];
        AmountField[8] := NewAmountField[8];
        CurrencyField[8] := NewCurrencyField[8];
        ExcludeJobTask := NewExcludeJobTask;
    end;
}

