page 51330 "Appraisal Criteria"
{
    PageType = List;
    SourceTable = "Appraisal Criteria";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Criteria; Rec.Criteria)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Criteria field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Appraisal Year"; Rec."Appraisal Year")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Appraisal Year field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(Indicators)
            {
                Caption = 'Indicators';
                action("Category Indicators")
                {
                    Caption = 'Category Indicators';
                    Image = InwardEntry;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Appraisal Indicators";
                    RunPageLink = Criteria = FIELD(Criteria),
                                  "Appraisal Year" = FIELD("Appraisal Year");
                    ToolTip = 'Executes the Category Indicators action.';
                }
            }
        }
    }
}

