page 50019 "Student Clearance Card"
{
    PageType = card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Student Clearance";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Student No"; Rec."Student No")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Student No field.';

                }
                field(Names; Rec.Names)
                {
                    ApplicationArea = basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Names field.';
                }
                field(Date; Rec.date)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Date field.';

                }
                field("Fully Cleared"; Rec."Fully Cleared")
                {
                    ApplicationArea = basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Fully Cleared field.';

                }
                field("Finance"; Rec."Finance")
                {

                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Finance field.';

                }
                field("Store"; Rec."Store")
                {

                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Store field.';

                }
                field("Footwear section"; Rec."Footwear section")
                {

                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Footwear section field.';

                }
                field("Leather goods section"; Rec."Leather goods section")
                {

                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Leather goods section field.';

                }
                field("Laboratory"; Rec."Laboratory")
                {

                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Laboratory field.';

                }
                field("Human Resource"; Rec."Human Resource")
                {

                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Human Resource field.';

                }
                field("Centre Administrator"; Rec."Centre Administrator")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Centre Administrator field.';

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