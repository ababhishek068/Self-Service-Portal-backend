page 51233 "HR Qualification Category"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "HR Lookup Values";
    SourceTableView = where(Type = filter("Qualification category"));
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
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field(Score; Rec.Score)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Score field.';

                }
            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action("Qualification Codes")
            {
                ApplicationArea = All;
                RunObject = page "HR Qualification Codes";
                RunPageLink = Type = filter(Course), Category = field(Category), "Sub Category" = field(code);
                ToolTip = 'Executes the Qualification Codes action.';
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.Type::"Qualification category";
        Rec."Sub Category" := Rec.code;

    end;
}