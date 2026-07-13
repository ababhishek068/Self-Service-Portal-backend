pageextension 50042 "Posted Purchase Receipt Ext" extends "Posted Purchase Receipt"
{
    layout { }

    actions
    {
        modify("&Print")
        {
            Visible = false;
        }
        addafter("&Print")
        {
            action(PrintGRN)
            {
                Caption = 'Print';
                ApplicationArea = basic;
                Promoted = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Print action.';
                trigger OnAction()
                var
                    PurchReceipt: Record "Purch. Rcpt. Header";
                    GRN: Report "Goods Receipt Note(GRN)";
                begin
                    PurchReceipt.reset;
                    PurchReceipt.setfilter(PurchReceipt."No.", Rec."No.");
                    if PurchReceipt.find('-') then begin
                        GRN.SetTableView(PurchReceipt);
                        GRN.Run();
                    end;
                    // report.run(70135449, true, true, PurchReceipt);
                end;
            }
            action(PrintCert)
            {
                Caption = 'Print Inspection Certificate';
                ApplicationArea = basic;
                Promoted = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Print Inspection Certificate action.';
                trigger OnAction()
                var
                    PurchReceipt: Record "Purch. Rcpt. Header";
                    InspecReport: report "Inspection Certificate1";
                begin
                    PurchReceipt.reset;
                    PurchReceipt.setfilter(PurchReceipt."No.", Rec."No.");
                    if PurchReceipt.find('-') then begin
                        InspecReport.SetTableView(PurchReceipt);
                        InspecReport.Run();
                    end;

                    //  report.run(70135481, true, true, PurchReceipt);
                end;
            }
        }
    }
}