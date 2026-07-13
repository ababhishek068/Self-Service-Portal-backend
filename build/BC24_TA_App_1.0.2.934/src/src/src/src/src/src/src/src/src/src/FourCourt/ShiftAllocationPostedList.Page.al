page 51250 "Shift Allocation Posted List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Shift Allocation";
    CardPageId = "Shift Allocation Posted Card";
    Editable = false;
    SourceTableView = where(Posted = filter(True));
    layout
    {
        area(Content)
        {
            repeater(GroupName)
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