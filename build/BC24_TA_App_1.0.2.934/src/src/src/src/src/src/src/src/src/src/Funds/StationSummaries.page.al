page 50467 "Station Summaries"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Dimension Value";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the dimension value.';

                }
                field("Total Expenditure"; Rec."Total Expenditure")
                {
                    ToolTip = 'Specifies the value of the Total Expenditure field.';

                }
                field("Total Income Dept"; Rec."Total Income Dept")
                {
                    ToolTip = 'Specifies the value of the Total Income Dept field.';

                }
                field("Total Receipt"; Rec."Total Receipt")
                {
                    ToolTip = 'Specifies the value of the Total Receipt field.';
                }
                field("Total Receipt Cash"; Rec."Total Receipt Cash")
                {
                    ToolTip = 'Specifies the value of the Total Receipt Cash field.';
                }
                field("Total Receipt MPESA"; Rec."Total Receipt MPESA")
                {
                    ToolTip = 'Specifies the value of the Total Receipt MPESA field.';
                }
                field("Total Receipt PDQ"; Rec."Total Receipt PDQ")
                {
                    ToolTip = 'Specifies the value of the Total Receipt PDQ field.';
                }
                field(Totaling; Rec.Totaling)
                {
                    ToolTip = 'Specifies an account interval or a list of account numbers. The entries of the account will be totaled to give a total balance. How entries are totaled depends on the value in the Account Type field.';
                }
                field("Dimension Id"; Rec."Dimension Id")
                {
                    ToolTip = 'Specifies the value of the Dimension Id field.';
                }
                field("Dimension Value ID"; Rec."Dimension Value ID")
                {
                    ToolTip = 'Specifies the value of the Dimension Value ID field.';
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