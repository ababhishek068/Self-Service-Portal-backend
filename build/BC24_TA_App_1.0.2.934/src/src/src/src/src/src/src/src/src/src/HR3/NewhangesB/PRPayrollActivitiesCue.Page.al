page 51284 "PR Payroll Activities Cue"
{
    PageType = CardPart;
    SourceTable = "HR Activities Cue";
    ApplicationArea = All;

    layout
    {
        area(content)
        {

            cuegroup(PayrollActivites)
            {
                ShowCaption = false;
                field("Basic Pay"; Rec."Basic Pay")
                {
                    ApplicationArea = all;

                    Caption = 'Basic Pay';

                    /* trigger OnDrillDown()
                    var
                        HRCodeunit: Codeunit "HR Codeunit";
                    begin
                        HRCodeunit.DrillDownBasicPay();
                    end */
                    ;
                    ToolTip = 'Specifies the value of the Basic Pay field.';
                }

                field("Net Pay"; Rec."Net Pay")
                {
                    ApplicationArea = all;
                    Caption = 'Net Pay';
                    ToolTip = 'Specifies the value of the Net Pay field.';

                    // trigger OnDrillDown()
                    // var
                    //     HRCodeunit: Codeunit "HR Codeunit";
                    // begin
                    //     HRCodeunit.DrillDownNetPay();
                    // end; 
                }

                field(Allowances; Rec.Allowances)
                {
                    ApplicationArea = all;
                    Caption = 'Allowances';
                    ToolTip = 'Specifies the value of the Allowances field.';
                }

                field("INCOME TAX"; Rec.PAYE)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Income Tax field.';
                }

                field(NHIF; Rec.NHIF)
                {
                    ApplicationArea = all;
                    Caption = 'NHIF';
                    Visible=false;
                    ToolTip = 'Specifies the value of the NHIF field.';
                }

                field(Pension; Rec.Pension)
                {
                    ApplicationArea = all;
                    Caption = 'Pension';
                    ToolTip = 'Specifies the value of the Pension field.';
                }

                // field("Voluntary Pension"; Rec."Voluntary Pension")
                // {
                //     ApplicationArea = all;
                //     ToolTip = 'Specifies the value of the Voluntary Pension field.';
                // }

                field("Pension-Employee"; Rec."Pension-Employee")
                {
                    ApplicationArea = all;
                    Caption = 'Pension - Employee';
                    ToolTip = 'Specifies the value of the Pension - Employee field.';
                }

                field("Pension-Employer"; Rec."Pension-Employer")
                {
                    ApplicationArea = all;
                    Caption = 'Pension - Employer';
                    ToolTip = 'Specifies the value of the Pension - Employer field.';
                }

                field("Voluntary Pension"; Rec."Voluntary Pension")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Voluntary Pension field.';
                }
            }
        }

    }
    trigger OnOpenPage();
    begin

        Rec.RESET;
        IF NOT Rec.GET THEN BEGIN
            Rec.INIT;
            Rec.INSERT;
        END;
    end;
}




