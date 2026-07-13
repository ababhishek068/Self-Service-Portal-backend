page 50514 "Case Investigation List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = cases;
    CardPageId = "Case Investigation Card";
    SourceTableView = where(status = filter(<> ""));
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Case No"; Rec."Case No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Case No field.';

                }
                field("Case Date"; Rec."Case Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Case Date field.';

                }
                field("Case Nature"; Rec."Case Nature")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Case Nature field.';

                }
                field("Type of Offence"; Rec."Type of Offence")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type of Offence field.';

                }
                field("Offense Date"; Rec."Offense Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Offense Date field.';

                }
                field("Offense Time"; Rec."Offense Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Offense Time field.';

                }
                field("Offense Place"; Rec."Offense Place")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Offense Place field.';

                }
                field("Amount Involved"; Rec."Amount Involved")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount Involved field.';

                }
                field("Amount Recovered"; Rec."Amount Recovered")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount Recovered field.';

                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Balance field.';

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