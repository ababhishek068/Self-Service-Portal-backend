Page 51074 "Application Setup Grade List"
{
    CardPageId = "Application Setup Grade";
    PageType = List;
    SourceTable = "Application Setup Grade";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Grade; Rec.Grade)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Grade field.';
                }
                field(Points; Rec.Points)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Points field.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Category field.';
                }
            }
        }
    }

    actions { }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

