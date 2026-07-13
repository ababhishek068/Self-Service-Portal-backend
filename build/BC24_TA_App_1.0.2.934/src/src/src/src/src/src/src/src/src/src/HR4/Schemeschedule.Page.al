Page 50443 "Scheme schedule"
{
    PageType = ListPart;
    SourceTable = "Medical Cover Type";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SchemeNo; Rec."Scheme No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Scheme No field.';
                }
                field(CoverType; Rec."Cover Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cover Type field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(CATA; Rec."CAT A")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the CAT A field.';
                }
                field(CATB; Rec."CAT B")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the CAT B field.';
                }
                field(CATC; Rec."CAT C")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the CAT C field.';
                }
                field(CATD; Rec."CAT D")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the CAT D field.';
                }
                field(CATE; Rec."CAT E")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the CAT E field.';
                }
            }
        }
    }

    actions { }
}

