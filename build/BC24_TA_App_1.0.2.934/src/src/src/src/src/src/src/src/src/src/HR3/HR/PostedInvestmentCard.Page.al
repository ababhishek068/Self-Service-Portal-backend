Page 50530 "Posted Investment Card"
{
    Editable = false;
    PageType = Card;
    SourceTable = "Investment Header";
    SourceTableView = where("Investment Rollover Status" = filter(Closed));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field(InvestmentStartDate; Rec."Investment Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Start Date field.';
                }
                field(InvestmentEndDate; Rec."Investment End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment End Date field.';
                }
                field(InvestmentDuration; Rec."Investment Duration")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Duration field.';
                }
                field(InvestmentCompanyCode; Rec."Investment Company Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Company Code field.';
                }
                field(InvestmentCompanyName; Rec."Investment Company Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Company Code field.';
                }
                field(InvestmentType; Rec."Investment Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Type field.';
                }
                field(PayingDocumentNo; Rec."Paying Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Paying Document No. field.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PaymentHeader: Record "Payments Header" temporary;
                        PaymentLines: Record "Payment Line";
                    begin

                        PaymentLines.Reset;
                        PaymentLines.SetRange(PaymentLines.Type, 'INVESTMENT');
                        if PaymentLines.Find('-') then begin
                            //Popultate payment table with investment pvs
                            PaymentHeader.Reset;
                            PaymentHeader.DeleteAll;

                            repeat
                                Payments.Get(PaymentLines.No);
                                PaymentHeader.SetRange(PaymentHeader."No.", PaymentLines.No);
                                if not PaymentHeader.Find('-') then begin
                                    PaymentHeader.TransferFields(Payments);
                                    PaymentHeader.Insert;
                                end;


                            until PaymentLines.Next = 0;
                            //PAGE.RUN(PAGE::"Payment Vouchers List",PaymentHeader);
                        end;
                        Page.Run(Page::"Payment Vouchers List", PaymentHeader);
                    end;
                }
                field(InvestmentPrincipal; Rec."Investment Principal")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Principal field.';
                }
                field(InvestmentRate; Rec."Investment Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Rate field.';
                }
                field(ExpectedInterest; Rec."Expected Interest")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Expected Interest field.';
                }
                field(InterestEarned; Rec."Interest Earned")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Interest Earned field.';
                }
                field(WithholdingTaxRate; Rec."Withholding Tax Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Withholding Tax Rate field.';
                }
                field(InvestmentWithholdingTax; Rec."Investment Withholding Tax")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Withholding Tax field.';
                }
                field(InvestmentRolloverStatus; Rec."Investment Rollover Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Rollover Status field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control18; Links) { }
            systempart(Control19; MyNotes) { }
        }
    }

    actions
    {
        area(processing)
        {
            action(Print)
            {
                ApplicationArea = Basic;
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Executes the Print action.';

                trigger OnAction()
                begin
                    Rec.Reset;
                    Rec.SetFilter("No.", Rec."No.");
                    // Report.Run(Report::"A Third Rule Report",true,true,Rec);
                    Rec.Reset;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        //IF (Status <> Status::" ") AND (Status<> Status::Open) THEN CurrPage.EDITABLE(FALSE);
    end;

    var
        Payments: Record "Payments Header";

    local procedure Close()
    begin
    end;

    local procedure Rollover()
    begin
    end;
}

