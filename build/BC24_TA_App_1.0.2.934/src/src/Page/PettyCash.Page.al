page 50881 "Petty Cash"
{
    CardPageID = "Petty Cash Payment Card";
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = Basic;
    SourceTable = "Payments Header";
    SourceTableView = WHERE("Payment Type" = FILTER("Petty Cash"),
                            Status = FILTER(Pending | "Pending Approval" | Approved),
                            Posted = CONST(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Factor field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payee field.';
                }
                field("On Behalf Of"; Rec."On Behalf Of")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the On Behalf Of field.';
                }
                field(Cashier; Rec.Cashier)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cashier field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field("Date Posted"; Rec."Date Posted")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Posted field.';
                }
                field("Time Posted"; Rec."Time Posted")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Time Posted field.';
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted By field.';
                }
                field("Total Payment Amount"; Rec."Total Payment Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Payment Amount field.';
                }
                field("Paying Bank Account"; Rec."Paying Bank Account")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Paying Bank Account field.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Type field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field("Function Name"; Rec."Function Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Function Name field.';
                }
                field("Budget Center Name"; Rec."Budget Center Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budget Center Name field.';
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field(Select; Rec.Select)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Select field.';
                }
                field("Total VAT Amount"; Rec."Total VAT Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total VAT Amount field.';
                }
                field("Total Witholding Tax Amount"; Rec."Total Witholding Tax Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Witholding Tax Amount field.';
                }
                field("Total Net Amount"; Rec."Total Net Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Net Amount field.';
                }
                field("Current Status"; Rec."Current Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Status field.';
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque No. field.';
                }
                field("Pay Mode"; Rec."Pay Mode")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pay Mode field.';
                }
                field("Payment Release Date"; Rec."Payment Release Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Release Date field.';
                }
                field("No. Printed"; Rec."No. Printed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Printed field.';
                }
                field("VAT Base Amount"; Rec."VAT Base Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the VAT Base Amount field.';
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Exchange Rate field.';
                }
                field("Currency Reciprical"; Rec."Currency Reciprical")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency Reciprical field.';
                }
                field("Current Source A/C Bal."; Rec."Current Source A/C Bal.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Source A/C Bal. field.';
                }
                field("Cancellation Remarks"; Rec."Cancellation Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cancellation Remarks field.';
                }
                field("Register Number"; Rec."Register Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Register Number field.';
                }
                field("From Entry No."; Rec."From Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From Entry No. field.';
                }
                field("To Entry No."; Rec."To Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To Entry No. field.';
                }
                field("Invoice Currency Code"; Rec."Invoice Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Invoice Currency Code field.';
                }
                field("Total Payment Amount LCY"; Rec."Total Payment Amount LCY")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Payment Amount LCY field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(Dim3; Rec.Dim3)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dim3 field.';
                }
                field(Dim4; Rec.Dim4)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dim4 field.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field("Cheque Type"; Rec."Cheque Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque Type field.';
                }
                field("Total Retention Amount"; Rec."Total Retention Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Retention Amount field.';
                }
                field("Payment Narration"; Rec."Payment Narration")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payment Narration field.';
                }
                field("Total PAYE Amount"; Rec."Total PAYE Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total PAYE Amount field.';
                }
                field("Reference No."; Rec."Reference No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reference No. field.';
                }
                field("Cheque Printed"; Rec."Cheque Printed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cheque Printed field.';
                }


                field("PF No"; Rec."PF No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PF No field.';
                }

            }
        }
    }

    actions { }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //  "Responsibility Center" := 'KARU';
    end;
}

