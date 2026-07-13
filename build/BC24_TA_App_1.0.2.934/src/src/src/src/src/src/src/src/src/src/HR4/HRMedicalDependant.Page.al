Page 51342 "HR Medical Dependant"
{
    PageType = ListPart;
    SourceTable = "HR Medical Dependants";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(FirstName; Rec."First Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the First Name field.';
                }
                field(LastName; Rec."Last Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Last Name field.';
                }
                field(Designation; Rec.Designation)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Designation field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(SchemeJoinDate; Rec."Scheme Join Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Scheme Join Date field.';
                }
                field(SchemeAnniversary; Rec."Scheme Anniversary")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Scheme Anniversary field.';
                }
                field(DateofBirth; Rec."Date of Birth")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date of Birth field.';
                }
                field(Below25Yrs; Rec."Below 25 Yrs")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Below 25 Yrs field.';
                }
                field(SecondName; Rec."Second Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Second Name field.';
                }
                field(Twins; Rec.Twins)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Twins field.';
                }
                field(PolicyNo; Rec."Policy No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Policy No field.';
                }
                field(Names; Rec.Names)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Names field.';
                }
                field(Relation; Rec.Relation)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Relation field.';
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contact field.';
                }
                field("Dependant Member No."; Rec."Dependant Member No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dependant Member No. field.';
                }
            }
        }
    }

    actions { }
}

