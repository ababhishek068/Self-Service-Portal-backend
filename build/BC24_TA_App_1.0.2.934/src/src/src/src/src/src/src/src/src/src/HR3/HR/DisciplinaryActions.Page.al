Page 51214 "Disciplinary Actions"
{
    PageType = List;
    SourceTable = "Disciplinary Actions";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Terminate; Rec.Terminate)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Terminate field.';
                }
                field(Document; Rec.Document)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Document field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
            }
        }
    }

    actions { }
}

