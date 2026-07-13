page 51433 "Pump Reading List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Pump Reading Header";
    CardPageId = "Pump Reading Card";
    SourceTableView = where(Posted = filter(false));
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';

                }

                field("Station Code"; Rec."Station Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Station Code field.';

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';

                }
                field("Staff No"; Rec."Staff No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Staff No field.';

                }
                field("Total Reading Amount"; Rec."Total Reading Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Reading Amount field.';

                }
                field("Total Invoice Amount"; Rec."Total Invoice Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Invoice Amount field.';

                }
                field("Total Pump Return Amount"; Rec."Total Pump Return Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Pump Return Amount field.';

                }
                field("Total Cash Amount"; Rec."Total Reading Amount" - Rec."Total Invoice Amount" - Rec."Total Pump Return Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Reading Amount - Rec.Total Invoice Amount - Rec.Total Pump Return Amount field.';

                }

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
                ToolTip = 'Executes the ActionName action.';

                trigger OnAction();
                begin

                end;
            }
        }
    }
}