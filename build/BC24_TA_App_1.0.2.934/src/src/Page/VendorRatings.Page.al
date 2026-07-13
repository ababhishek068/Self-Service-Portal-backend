page 51294 "Vendor Ratings"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Vendor Rating";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Financial Period"; Rec."Financial Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Financial Period field.';

                }
                field("Rating Code"; Rec."Rating Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rating Code field.';

                }
                field("Rating Description"; Rec."Rating Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rating Description field.';

                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';

                }
                field("Rating Date"; Rec."Rating Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Rating Date field.';

                }
                field(Quality; Rec.Quality)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quality field.';

                }
                field(Cost; Rec.Cost)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cost field.';

                }
                field(Timeliness; Rec.Timeliness)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Timeliness field.';

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