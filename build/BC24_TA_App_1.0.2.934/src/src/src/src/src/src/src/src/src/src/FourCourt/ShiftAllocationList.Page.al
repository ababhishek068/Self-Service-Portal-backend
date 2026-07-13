page 51399 "Shift Allocation List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Shift Allocation";
    CardPageId = "Shift Allocation Card";
    Editable = false;
    SourceTableView = where(Posted = filter(false));
    layout
    {
        area(Content)
        {
            repeater(RepeaterName)
            {
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
                field(Open; Rec.Open)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Open field.';

                }
                field("Opened By"; Rec."Opened By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Opened By field.';

                }
                field("Opening Date"; Rec."Opening Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Opening Date field.';

                }
            }


        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action(Post)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the Post action.';

                trigger OnAction();
                begin

                end;
            }
        }
    }
}