page 51410 "Pending Invoice Card"
{
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Sales Invoice Header";
    SourceTableView = where("Invoice Cleared" = filter(false));
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the number of the customer the invoice concerns.';

                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the customer that you shipped the items on the invoice to.';

                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the date when the invoice was posted.';

                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies any text that is entered to accompany the posting, for example for information to auditors.';

                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';

                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';

                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the total of the amounts, including VAT, on all the lines on the document.';

                }
                field("Ship-to Contact1"; Rec."Ship-to Contact")
                {
                    caption = 'Truck No';
                    ToolTip = 'Specifies the name of the contact person at the address that the items are shipped to.';
                }
                field("Ship-to Address1"; Rec."Ship-to Address")
                {
                    caption = 'Driver Name';
                    ToolTip = 'Specifies the address that the items on the invoice were shipped to.';
                }
                field("Ship-to Address 22"; Rec."Ship-to Address 2")
                {
                    caption = 'Drivers ID';
                    ToolTip = 'Specifies additional address information.';
                }
                field("Ship-to Name1"; Rec."Ship-to Name")
                {
                    caption = 'Transporter';
                    ToolTip = 'Specifies the name of the customer at the address that the items are shipped to.';
                }
            }
            part("SalesInvoiceSubformPending"; "Sales Invoice Subform Pending")
            {
                Caption = 'Invoice Lines';
                SubPageLink = "Document No." = field("No.");
            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                Caption = 'Post Adjustments';
                Image = AdjustItemCost;
                ToolTip = 'Executes the Post Adjustments action.';
                trigger OnAction();
                begin
                    if Confirm('Do you reall want to post the adjustments?', false) then begin
                        PostItems();
                        Rec."Invoice Cleared" := true;
                        Rec.modify;
                    end;
                end;
            }
        }
    }
    procedure PostItems()
    var
        ForeCourt: Record "Fore Court Setup";
        ItemJnlLine: Record "Item Journal Line";
        PumpLine: Record "Sales Invoice Line";
        LineNo: Integer;
    begin


        ForeCourt.get;
        ForeCourt.TestField("Item Journal Template");
        ForeCourt.TestField("Item Journal Batch");
        ItemJnlLine.Reset;
        ItemJnlLine.SetRange(ItemJnlLine."Journal Template Name", ForeCourt."Item Journal Template");
        ItemJnlLine.SetRange(ItemJnlLine."Journal Batch Name", ForeCourt."Item Journal Batch");
        if ItemJnlLine.Find('-') then ItemJnlLine.DeleteAll;
        LineNo := 0;
        PumpLine.Reset;
        PumpLine.SetRange(PumpLine."Document No.", Rec."No.");
        if PumpLine.Find('-') then begin

            repeat
                if PumpLine."Shipped Qty Variance" > 0 then begin
                    LineNo := LineNo + 1000;
                    ItemJnlLine.Init;
                    ItemJnlLine."Journal Template Name" := ForeCourt."Item Journal Template";
                    ItemJnlLine."Journal Batch Name" := ForeCourt."Item Journal Batch";
                    ItemJnlLine."Line No." := LineNo;
                    ItemJnlLine."Posting Date" := Today;
                    ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
                    ItemJnlLine."Document No." := PumpLine."Document No.";

                    ItemJnlLine."Item No." := PumpLine."No.";
                    ItemJnlLine.Validate(ItemJnlLine."Item No.");
                    ItemJnlLine."Location Code" := PumpLine."Location Code";
                    ItemJnlLine.Validate(ItemJnlLine."Location Code");
                    ItemJnlLine.Quantity := PumpLine."Shipped Qty Variance";
                    ItemJnlLine.Validate(ItemJnlLine.Quantity);

                    ItemJnlLine."Unit of Measure Code" := PumpLine."Unit of Measure Code";
                    ItemJnlLine.Validate(ItemJnlLine."Unit of Measure Code");
                    ItemJnlLine."Unit Amount" := PumpLine."Unit Price";
                    ItemJnlLine."Shortcut Dimension 1 Code" := PumpLine."Shortcut Dimension 1 Code";
                    ItemJnlLine."Shortcut Dimension 2 Code" := PumpLine."Shortcut Dimension 2 Code";
                    // ItemJnlLine.VALIDATE(ItemJnlLine."Unit Amount");
                    ItemJnlLine.Validate("Shortcut Dimension 1 Code");
                    ItemJnlLine.Validate("Shortcut Dimension 2 Code");
                    ItemJnlLine.Insert();

                    LineNo := LineNo + 1;
                end;
            until PumpLine.Next = 0;

            ItemJnlLine.Reset;
            ItemJnlLine.SetRange("Journal Template Name", ForeCourt."Item Journal Template");
            ItemJnlLine.SetRange("Journal Batch Name", ForeCourt."Item Journal Batch");
            if ItemJnlLine.Find('-') then
                CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post Batch", ItemJnlLine);

        end;
    end;
}