Page 50059 "HR Employee Beneficiary"
{

    Caption = 'Employee  Beneficiaries';
    PageType = List;
    SourceTable = "HR Employee Kin";
    ApplicationArea = All;
    // SourceTableView = where(Type = filter(Beneficiary));

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field(Relationship; Rec.Relationship)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Relationship field.';
                }
                field(SurName; Rec.SurName)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the SurName field.';
                }
                field(OtherNames; Rec."Other Names")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Other Names field.';
                }
                field("Identification Type"; Rec."Identification Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Identification Type field.';
                }
                field("Card No"; Rec."Card No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Card No field.';
                }
                field(Occupation; Rec.Occupation)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Occupation field.';
                }
                field(DateOfBirth; Rec."Date Of Birth")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Of Birth field.';
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
                field(Percentage; Rec."Percentage(%)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Percentage(%) field.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comment field.';
                }
            }
        }
    }

    actions
    {

        area(Reporting)
        {
            action("Print Next of Kin Form")
            {
                   Caption = 'Employee Family List Record form';
                    Image = PrintDocument;
                    Promoted = true;
                    ApplicationArea = Basic;
                    PromotedCategory = Report;
                    ToolTip = 'Executes the Print Family List action.';
                    trigger OnAction()
                    var
                    Nextofkin: record "HR Employee Kin";
                    nextofkinReport: Report "next of kin";
                    begin
                        Nextofkin.SetCurrentKey("Employee Code");
                        Nextofkin.SetFilter(Type,'Next of Kin');                       
                        nextofkinReport.SetTableView(Nextofkin);
                        nextofkinReport.Run();

                        
                    end;
 


            }
        }
        area(navigation)
        {
            group(NextofKin)
            {
                Caption = '&Next of Kin';
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name" = const("Employee Relative"),
                                  "No." = field("Employee Code"),
                                  "Table Line No." = field("Line No.");
                    ToolTip = 'Executes the Co&mments action.';
                }
            }
        }
    }

}

