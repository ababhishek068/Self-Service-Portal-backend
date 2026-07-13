Page 50115 "Student Kin"
{
    PageType = ListPart;
    SourceTable = "Student Kin";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Relationship; Rec.Relationship)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Relationship field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(OtherNames; Rec."Other Names")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Other Names field.';
                }
                field(IDNoPassportNo; Rec."ID No/Passport No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the ID No/Passport No field.';
                }
                field(DateOfBirth; Rec."Date Of Birth")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Of Birth field.';
                }
                field(Occupation; Rec.Occupation)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Occupation field.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field(OfficeTelNo; Rec."Office Tel No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Office Tel No field.';
                }
                field(HomeTelNo; Rec."Home Tel No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Home Tel No field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
        }
    }

    actions { }
}

