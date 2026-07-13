page 50345 "Audit Notifications Card"
{
    PageType = card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Audit Notifications";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field(Programme; Rec.Programme)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Programme field.';

                }
                field("Message 1"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field(Objectives1; Rec.Objectives1)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Objectives1 field.';

                }
                field(Objectives2; Rec.Objectives2)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Objectives2 field.';

                }
                field(Receiver; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field("Read?"; Rec."Read?")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Read? field.';

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