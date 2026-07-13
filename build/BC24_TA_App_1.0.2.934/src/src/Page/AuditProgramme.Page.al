page 50133 "Audit Programme"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Audit Programmes";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Title field.';

                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category field.';

                }
                field("Description/Comment"; Rec."Description/Comment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description/Comment field.';

                }
                field("Notification Sent?"; Rec."Notification Sent?")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Notification Sent? field.';

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Audit)
            {
                caption = 'Audits';
                ApplicationArea = All;
                RunObject = page Audit;
                RunPageLink = "Audit Programme" = field(Code);
                ToolTip = 'Executes the Audits action.';

            }
            action(AuditLines)
            {
                caption = 'Audit Programme Lines';
                ApplicationArea = All;
                RunObject = page "Audit Programme Lines";
                RunPageLink = "Code" = field(Code);
                ToolTip = 'Executes the Audit Programme Lines action.';

            }


        }
    }
}