Page 51242 "Maintanance Type"
{
    PageType = List;
    SourceTable = "Maintanance Types";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(MaintananceCode; Rec."Maintanance Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Maintanance Code field.';
                }
                field(MaintananceDescription; Rec."Maintanance Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Maintanance Description field.';
                }
            }
        }
    }

    actions { }
}

