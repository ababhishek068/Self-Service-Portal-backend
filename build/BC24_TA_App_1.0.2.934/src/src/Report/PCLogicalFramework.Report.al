report 50278 "PC Logical Framework"
{
    DefaultLayout = RDLC;
    RDLCLayout = './LogicalFramework.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItem1; "PC Key Results Area")
        {
            column(CompanyInformationName; CompanyInformation.Name) { }
            column(CompanyInformationAddress; CompanyInformation.Address) { }
            column(CompanyInformationAddress2; CompanyInformation."Address 2") { }
            column(CompanyInformationCity; CompanyInformation.City) { }
            column(CompanyInformationPicture; CompanyInformation.Picture) { }
            column(Code; Code) { }
            column(Description; Description) { }
            column(Strategic_Plan; "Strategic Plan") { }
            column(Strategic_Objective; "Strategic Objective") { }
            dataitem(DataItem2; "PC Strategic Objectives")
            {
                DataItemLink = Code = FIELD("Strategic Objective");

                column(Code_obj; Code) { }
                column(Description_obj; Description) { }
                column(Strategic_Plan_obj; "Strategic Plan") { }
            }
            dataitem(DataItem3; "PC Impact")
            {
                DataItemLink = "Key Result Area" = FIELD(Code);

                column(Code_impact; Code) { }
                column(Description_impact; Description) { }
                column(Strategic_Plan_impact; "Strategic Plan") { }
                column(Objective_impact; Objective) { }
                column(Type_impact; Type) { }
            }

        }
    }
    trigger OnPreReport()
    begin
        CompanyInformation.RESET();
        CompanyInformation.GET();
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
}