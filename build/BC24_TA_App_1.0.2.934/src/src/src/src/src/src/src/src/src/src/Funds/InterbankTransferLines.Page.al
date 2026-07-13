page 50998 "Interbank Transfer Lines"
{
    PageType = ListPart;
    SourceTable = "Interbank Transfer Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Paying Bank No"; Rec."Paying Bank No")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Paying Bank No field.';
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    Editable = false;
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Bank Name field.';
                }
                field("Receipt No"; Rec."Receipt No")
                {
                    DrillDownPageID = "Posted Receipt UP";
                    LookupPageID = "Posted Receipt UP";
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Receipt No field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Source Campus Code"; Rec."Source Campus Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Source Funtion Code field.';
                }
                field("Source Department Code"; Rec."Source Department Code")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Source Budget Center Code field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
            }
        }
    }


}

