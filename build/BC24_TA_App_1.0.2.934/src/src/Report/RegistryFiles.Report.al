Report 50246 "Registry Files"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/RegistryFiles.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Registry Files"; "Registry Files")
        {
            column(ReportForNavId_1; 1) { }
            column(folioNo; "Registry Files"."File No.") { }
            column(File_Desc; "Registry Files"."File Subject/Description") { }
            column(Issuing; "Registry Files"."Issuing Officer") { }
            column(Return; "Registry Files"."Expected Return Date") { }
            column(Reciving; "Registry Files"."Receiving Officer") { }
            column(F_Status; Format("Registry Files"."File Status")) { }
            column(CareOf; "Registry Files"."Care of") { }
            column(Type; Format("Registry Files"."File Type")) { }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }
}

