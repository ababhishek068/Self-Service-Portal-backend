page 50210 "Supply Chain Headline"
{
    PageType = HeadlinePart;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                ShowCaption = false;
                field(Welcome; Welcome)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Welcome field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var

    begin
        Welcome := WelcomeLbl;
    end;

    var
        WelcomeLbl: Label 'Welcome: Supply Chain Management Role Center';
        Welcome: Text;
}