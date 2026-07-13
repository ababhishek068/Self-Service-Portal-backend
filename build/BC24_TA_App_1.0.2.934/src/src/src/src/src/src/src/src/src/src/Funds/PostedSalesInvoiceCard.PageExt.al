pageextension 50006 "Posted Sales Invoice Card" extends "Posted Sales Invoice"
{
    actions
    {
        addafter(Print)
        {
            action("Print Credit Sales")
            {
                Caption = 'Print Credit Sales Invoice ';
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Print/Preview action.';

                trigger OnAction()
                begin
                    //TESTFIELD(Status,Status::Approved);
                    Rec.Reset;
                    Rec.SetFilter("No.", Rec."No.");
                    if rec.FindFirst() then begin
                        REPORT.Run(50356, true, false, Rec);
                    end;

                end;



            }
            action("Print Cash Sales")
            {
                Caption = 'Print Cash Sales Invoice ';
                ApplicationArea = Basic;
                Promoted = true;
                PromotedCategory = Report;
                ToolTip = 'Executes the Print/Preview action.';

                trigger OnAction()
                begin
                    //TESTFIELD(Status,Status::Approved);
                    Rec.Reset;
                    Rec.SetFilter("No.", Rec."No.");
                    if rec.FindFirst() then begin
                        REPORT.Run(50357, true, false, Rec);
                    end;

                end;

            }
        }
    }
}
