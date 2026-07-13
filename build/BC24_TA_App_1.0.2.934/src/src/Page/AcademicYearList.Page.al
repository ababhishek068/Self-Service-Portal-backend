page 50955 "Academic Year List"
{
    //  CardPageID = "Academic Year Card";
    PageType = List;
    SourceTable = "Academic Year";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Current; Rec.Current)
                {
                    ToolTip = 'Specifies the value of the Current field.';
                }
            }
        }
    }

    actions
    {
        area(creation) { }
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

