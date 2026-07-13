Page 50802 "Treasury Bill Card"
{
    PageType = Card;
    SourceTable = "Investment Header";
    SourceTableView = where(Status = const(Open),
                            "Investment Category" = const("Treasury Bills"));
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
                field(InvestmentStartDate; Rec."Investment Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Start Date field.';
                }
                field(InvestmentDuration; Rec."Investment Duration")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Duration field.';
                }
                field(InvestmentEndDate; Rec."Investment End Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Investment End Date field.';
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field(InvestmentCompanyCode; Rec."Investment Company Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Company Code field.';
                }
                field(InvestmentCompanyName; Rec."Investment Company Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Investment Company Code field.';
                }
                field(InvestmentType; Rec."Investment Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Investment Type field.';
                }
                field(PayingDocumentNo; Rec."Paying Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Paying Document No. field.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        PaymentLines.Reset;
                        PaymentLines.SetRange(PaymentLines.Type, 'INVESTMENT');     //INVESTMENT
                        PaymentLines.SetRange(PaymentLines.Invested, false);
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
                        PaymentHeader.Reset;
                        if Page.RunModal(Page::"Posted Payment Vouchers", PaymentHeader) = Action::LookupOK then begin
                            Rec."Paying Document No." := PaymentHeader."No.";
                        end;
                    end;
                }
                field(FaceValue; Rec."Face Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Face Value field.';
                }
                field(InvestmentPrincipal; Rec."Investment Principal")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investment Principal field.';
                }
                field(TreasuryBondRate; Rec."Treasury Bond Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Treasury Bond Rate field.';
                }
                field(InterestEarned; Rec."Interest Earned")
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
                    Editable = false;
                    ToolTip = 'Specifies the value of the Investment Withholding Tax field.';
                }
                field(ExpectedInterest; Rec."Expected Interest")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Expected Interest field.';
                }
                field(TreasuryBondDisposalValue; Rec."Treasury Bond Disposal Value")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Treasury Bond Disposal Value field.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Responsibility Center field.';
                }
                field(Noofdayselapsed; Rec."No of days elapsed")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the No of days elapsed field.';
                }
                field(UserId; Rec."USER ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the USER ID field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(InvestmentCategory; Rec."Investment Category")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Investment Category field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(ActionGroup17)
            {
                action(Post)
                {
                    ApplicationArea = Basic;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Post action.';

                    trigger OnAction()
                    begin
                        if Rec."Investment End Date" > Today then Error('You can only post Treasury Bill on maturity');
                    end;
                }
                action(CalculateInterest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Calculate Interest';
                    Image = Calculate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Calculate Interest action.';

                    trigger OnAction()
                    begin
                        //IF "Interest Earned" = 0 THEN ERROR('Enter interest earned');
                        if Rec."Investment Principal" <> 0 then begin
                            Rec.TestField("Treasury Bond Rate");
                            Rec.TestField("Withholding Tax Rate");
                            InvestmentDays := Rec."Investment End Date" - Rec."Investment Start Date";
                            Rec."TB days" := InvestmentDays;
                            if InvestmentDays > 0 then begin
                                Rec."Interest Earned" := (Rec."Face Value" * Rec."Treasury Bond Rate" / 100) * InvestmentDays / 364;
                                Rec."Investment Withholding Tax" := Rec."Interest Earned" * Rec."Withholding Tax Rate" / 100;
                                Rec.CalcFields("Investment Principal");
                                Rec."Treasury Bond Disposal Value" := Rec."Face Value";
                            end;


                        end else
                            Rec."Expected Interest" := 0;
                        Message('Complete!');
                    end;
                }
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
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Investment Category" := Rec."investment category"::"Treasury Bills";
    end;

    trigger OnOpenPage()
    begin
        Rec.Status := Rec.Status::Open;
    end;

    var
        PaymentLines: Record "Payment Line";
        PaymentHeader: Record "Payments Header" temporary;
        Payments: Record "Payments Header";
        InvestmentDays: Integer;
}

