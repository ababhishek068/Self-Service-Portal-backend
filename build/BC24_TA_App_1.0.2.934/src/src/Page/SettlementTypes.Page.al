Page 50161 "Settlement Types"
{
    PageType = List;
    SourceTable = "Settlement Type";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(TuitionGLAccount; Rec."Tuition G/L Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Tuition G/L Account field.';
                }
                field("Billing By"; Rec."Billing By")
                {
                    Caption = 'Billing Method';
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Billing Method field.';
                }
                field("Fee Per Unit"; Rec."Fee Per Unit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Fee Per Unit field.';
                }
                field(RegNoPrefix; Rec."Reg. No Prefix")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reg. No Prefix field.';
                }

                field("Installment Charge Code"; Rec."Installment Charge Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Installment Charge Code field.';
                }

                field(Installments; Rec.Installments)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Installments field.';
                }
                field("Global Type"; Rec."Global Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Type field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(AllowOnlineRegistration; Rec."Allow Online Registration")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allow Online Registration field.';
                }
                field("Admissions Letter Report ID"; Rec."Admissions Letter Report ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Admissions Letter Report ID field.';
                }

            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Charges)
            {
                Caption = 'Charges';
                ApplicationArea = basic;
                Image = FinChargeMemo;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Stage Charges";
                RunPageLink = "Settlement Type" = field(Code);
                ToolTip = 'Executes the Charges action.';
            }


        }
    }
}

