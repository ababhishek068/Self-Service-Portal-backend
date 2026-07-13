pageextension 50057 "Sales Quote" extends "Sales Quote"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        modify(Print)
        {
            Visible = false;
        }
        addafter(Print)
        {
            action(Print2)
            {
                caption = 'Print';
                ApplicationArea = basic;
                Image = Print;
                ToolTip = 'Executes the Print action.';
                trigger OnAction()
                var
                    SaleQoueRep: report "Sales - Quote Report";
                    SHeader: record "Sales Header";
                begin
                    sheader.reset;
                    sHeader.setfilter("No.", Rec."No.");
                    if sheader.find('-') then begin
                        SaleQoueRep.SetTableView(sheader);
                        SaleQoueRep.Run();
                    end;
                end;
            }
        }
    }
}