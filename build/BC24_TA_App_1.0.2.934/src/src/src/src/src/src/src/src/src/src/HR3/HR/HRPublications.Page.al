Page 50522 "HR Publications"
{
    PageType = List;
    SourceTable = "HR Publications";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(username; Rec.username)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the username field.';
                }
                field(EmailAddress; Rec."Email Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Email Address field.';
                }
                field(Author; Rec.Author)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Author field.';
                }
                field(TitleOfPublication; Rec."Title Of Publication")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Title Of Publication field.';
                }
                field(Publisher; Rec.Publisher)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Publisher field.';
                }
                field(YearOfPublication; Rec."Year Of Publication")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Year Of Publication field.';
                }
                field(LineNo; Rec."Line No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Line No field.';
                }
                field("Field"; Rec.Field)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Field field.';
                }
                field(NumberofAuthors; Rec."Number of Authors")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Number of Authors field.';
                }
                field(FieldofResearch; Rec."Field of Research")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Field of Research field.';
                }
                field(PositionofAuthor; Rec."Position of Author")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Position of Author field.';
                }
                field(Score; Rec.Score)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Score field.';
                }
            }
        }
    }

    actions { }
}

