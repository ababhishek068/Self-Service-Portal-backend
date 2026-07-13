page 50270 "NYS Service Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "NYS Service Setup";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Serial Nos"; Rec."Serial Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Serial Nos field.';

                }
                field("Service Nos"; Rec."Service Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Service Nos field.';

                }
                field("Training Nos"; Rec."Training Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Training Nos field.';

                }
                field("Deployment Nos"; Rec."Deployment Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deployment Nos field.';

                }
                field("Duty Allocation Nos"; Rec."Duty Allocation Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Duty Allocation Nos field.';

                }
                field("Disciplinary Nos"; Rec."Disciplinary Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Disciplinary Nos field.';

                }
                field("Complain Nos"; Rec."Complain Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Complain Nos field.';

                }
                field("Transfer Nos"; Rec."Transfer Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transfer Nos field.';

                }
                field("Clearance Nos"; Rec."Clearance Nos")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Clearance Nos field.';

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