Page 50254 "Investment"
{
    PageType = Card;
    SourceTable = Customer;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s name. This name will appear on all sales documents for the customer.';
                }
                field("Investing Company"; Rec."Investing Company")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Investing Company field.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s address. This address will appear on all sales documents for the customer.';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s city.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the postal code.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s email address.';
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the person you regularly contact when you do business with this customer.';
                }
                field("Certificate No."; Rec."Certificate No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Certificate No. field.';
                }
                field("Date of Issue"; Rec."Date of Issue")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of Issue field.';
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expiry Date field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Interest Rate"; "Interest Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Interest Rate field.';
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Duration field.';
                }
                label(Control1102756017)
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19042633;
                }
                field("Interest Earned"; "Interest Earned")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Interest Earned field.';
                }
                field("Maturity Amount"; Rec."Maturity Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Maturity Amount field.';
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s market type to link business transactions to.';
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer''s trade type to link transactions made for this customer with the appropriate general ledger account according to the general posting setup.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies when the customer card was last modified.';
                }
                field("Investment Period"; "Investment Period")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Investment Period field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Investment Report")
            {
                Caption = 'Investment Report';
                action("Report")
                {
                    ApplicationArea = Basic;
                    Caption = 'Report';
                    ShortCutKey = 'F9';
                    ToolTip = 'Executes the Report action.';

                    trigger OnAction()
                    begin
                        CUST.Reset;
                        CUST.SetRange(CUST."No.", Rec."No.");
                        if CUST.Find('-') then
                            Report.Run(39006015, true, false, CUST)
                    end;
                }
            }
        }
    }

    var
        "Interest Rate": Decimal;
        "Investment Period": DateFormula;
        "Interest Earned": Decimal;
        CUST: Record Customer;
        Text19042633: label 'MONTHS';
}

