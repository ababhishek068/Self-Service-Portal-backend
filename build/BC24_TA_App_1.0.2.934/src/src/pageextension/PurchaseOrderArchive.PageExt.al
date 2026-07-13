pageextension 50002 "Purchase Order Archive" extends "Purchase Order Archive"
{
    actions
    {
        addafter(Print)
        {
            action(PrintLpo)
            {


                Caption = 'Print LPO';
                ApplicationArea = basic;
                Image = Print;
                ToolTip = 'Executes the Print LPO action.';
                trigger OnAction()
                var
                    Purch: Record "Purchase Header Archive";
                    LPO: report "LPO Archived";
                begin
                    Purch.reset;
                    purch.setfilter(Purch."No.", Rec."No.");
                    if Purch.find('-') then begin
                        LPO.SetTableView(Purch);
                        LPO.Run();
                    end;
                end;
            }
            action(PrintLSo)
            {


                Caption = 'Print LSO';
                ApplicationArea = basic;
                Image = Print;
                ToolTip = 'Executes the Print LSO action.';
                trigger OnAction()
                var
                    Purch: Record "Purchase Header Archive";
                    LPO: report "LSO Archived";
                begin
                    Purch.reset;
                    purch.setfilter(Purch."No.", Rec."No.");
                    if Purch.find('-') then begin
                        LPO.SetTableView(Purch);
                        LPO.Run();
                    end;
                end;
            }

        }
    }
}
