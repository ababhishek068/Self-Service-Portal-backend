report 50352 "ME Logical Framework"
{
    RDLCLayout = './LogicalFramework.rdlc';
    ApplicationArea = All;
    dataset
    {
        dataitem("PC Strategies"; "PC Strategies")
        {
            RequestFilterFields = Code;
            column(Code; Code) { }
            column(Description; Description) { }
            column(Period_From; "Period From") { }
            column(Period_To; "Period To") { }
            column(Created_By; "Created By") { }
            column(Created_On; "Created On") { }
            column(Last_Modified_By; "Last Modified By") { }
            column(Last_Modified_On; "Last Modified On") { }
            dataitem("PC Outputs"; "PC Outputs")
            {
                DataItemLink = "Strategic Plan" = field(Code);
                DataItemTableView = sorting("Code") order(ascending);
                column(Output_Code; Code) { }
                column(Output_Description; Description) { }
                column(Output_Strategic_Plan; "Strategic Plan") { }
                column(Output_Strategic_Objective; "Strategic Objective") { }
                column(Output_Impact; Impact) { }
                column(Output_Outcome; Outcome) { }
                column(Output_Key_Result_Area; "Key Result Area") { }
                column(Output_Annual_Plan; "Annual Plan") { }
            }
            dataitem("PC Verifications"; "PC Verifications")
            {
                DataItemLink = "Strategic Plan" = field(Code);
                DataItemTableView = sorting("Code") order(ascending);
                column(Verif_Code; Code) { }
                column(Verif_Description; Description) { }
                column(Verif_Strategic_Plan; "Strategic Plan") { }
                column(Verif_Objective; Objective) { }
                column(Verif_Impact; Impact) { }
                column(Verif_Outcome; Outcome) { }
                column(Verif_Output; Output) { }
                column(Verif_Type; Type) { }
                column(Verif_Key_Result_Areas; "Key Result Areas") { }
                column(Verif_Annual_Plan; "Annual Plan") { }

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