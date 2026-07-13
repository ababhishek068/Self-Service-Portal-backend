page 50574 "ICT Requisition List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ICT General Requisition Header";
    CardPageId = "ICT Requisition Card";
    editable = false;
    SourceTableView = where("Resolution Status" = filter(<> Open));
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
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';

                }
                field("Requisition Category"; Rec."Requisition Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requisition Category field.';

                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';

                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';

                }
                field("General Description"; Rec."General Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the General Description field.';

                }
                field("Urgency Priority"; Rec."Urgency Priority")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Urgency Priority field.';

                }
                field("Required Date"; Rec."Required Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Required Date field.';

                }
                field("Resolution Status"; Rec."Resolution Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Resolution Status field.';

                }
                field("Resolution Remarks"; Rec."Resolution Remarks")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Resolution Remarks field.';

                }
                field(Assignee; Rec.Assignee)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assignee field.';

                }
                field("Requested By"; Rec."Requested By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Requested By field.';

                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the ActionName action.';

                trigger OnAction()
                begin

                end;
            }
        }
    }
}