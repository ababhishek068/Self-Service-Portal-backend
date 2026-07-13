page 50841 "Tender Subpage"
{
    PageType = ListPart;
    SourceTable = "Tender Plan Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            { 

                field(Stage; Rec.Stage)
                {
                    ToolTip = 'Specifies the value of the Stage field.';
                }
                field("Stage No";"Stage No"){}
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Planned start date"; Rec."Planned start date")
                {
                    ToolTip = 'Specifies the value of the Planned start date field.';
                }
                field("Planned end date"; Rec."Planned end date")
                {
                    ToolTip = 'Specifies the value of the Planned end date field.';

                    trigger OnValidate()
                    begin
                        Rec."Planned duration" := Rec."Planned end date" - Rec."Planned start date";
                    end;
                }
                field("Planned duration"; Rec."Planned duration")
                {
                    ToolTip = 'Specifies the value of the Planned duration field.';
                }
                field("Actual start date"; Rec."Actual start date")
                {
                    ToolTip = 'Specifies the value of the Actual start date field.';
                }
                field("Actual end date"; Rec."Actual end date")
                {
                    ToolTip = 'Specifies the value of the Actual end date field.';

                    trigger OnValidate()
                    begin
                        Rec."Actual Duration" := Rec."Actual end date" - Rec."Actual start date";
                    end;
                }
                field("Actual Duration"; Rec."Actual Duration")
                {
                    ToolTip = 'Specifies the value of the Actual Duration field.';
                }
            }
        }
    }

    actions { }
}

