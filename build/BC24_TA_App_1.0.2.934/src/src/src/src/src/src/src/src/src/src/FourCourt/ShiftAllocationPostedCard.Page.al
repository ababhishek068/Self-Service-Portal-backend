page 51248 "Shift Allocation Posted Card"
{
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Shift Allocation";
    Editable = false;
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'General';
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';

                }
                field("Station Code"; Rec."Station Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Station Code field.';

                }
                field("Shift Type"; Rec."Shift Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shift Type field.';

                }
                field("Special Discount"; Rec."Special Discount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Special Discount field.';

                }
                field("Special Discount Amount"; Rec."Special Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Special Discount Amount field.';

                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted By field.';

                }


            }
            group(Allocations)
            {
                part(Lines; "Shift Allocation Lines")
                {
                    ApplicationArea = basic;
                    caption = 'Staff Allocation';
                    SubPageLink = No = field(No);
                }
            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action(Post2)
            {
                ToolTip = 'Executes the Post2 action.';

            }
            action(Post)
            {
                ApplicationArea = All;
                Caption = 'R-Open Shift';
                ToolTip = 'Executes the R-Open Shift action.';
                trigger OnAction();
                var
                    ShiftLines: Record "Shift Allocation Line";
                    SalesPerson: Record "Salesperson/Purchaser";
                begin
                    if Confirm('Do you really want to re-open the shift?', false) then begin
                        ShiftLines.reset;
                        ShiftLines.setrange(No, Rec.No);
                        if ShiftLines.find('-') then begin
                            repeat
                                if SalesPerson.get(ShiftLines."Staff No") then begin
                                    SalesPerson.Active := true;
                                    SalesPerson.modify;
                                end;
                                ShiftLines.Posted := false;
                                ShiftLines.Open := true;
                                ShiftLines.modify;
                            until ShiftLines.next = 0;
                        end;
                        Rec.Posted := false;
                        Rec."Posted By" := UserId;
                        Rec."Posting Date" := today;
                        Rec.Modify();
                    end;
                end;
            }
            action(Post22)
            {
                ApplicationArea = All;
                Caption = 'Close All Shifts';
                ToolTip = 'Executes the Close All Shifts action.';
                trigger OnAction();
                var
                    ShiftH: Record "Shift Allocation";
                begin
                    ShiftH.reset;
                    if ShiftH.find('-') then begin
                        ShiftH.Posted := true;
                        ShiftH.Open := false;
                        ShiftH.modify;
                    end;
                end;
            }
        }
    }
}