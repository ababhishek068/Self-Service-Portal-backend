page 51232 "HR Qualification Type"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "HR Lookup Values";
    SourceTableView = where(Type = filter("Qualification Type"));
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
                field("Qualification Type"; Rec."Qualification Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Qualification Type field.';

                }
            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action("Qualification Category")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "HR Qualification Category";
                RunPageLink = Category = field(Code);
                ToolTip = 'Executes the Qualification Category action.';

            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.Type::"Qualification Type";
        Rec.Category := Rec.code;
    end;
}