       parameter(jdum=2000)
       CHARACTER*200 verfdir,clmverf
       CHARACTER*200 expdir,clmexp,plotdatadir
       CHARACTER*200 expname,varname
       CHARACTER*200 maskfile
       CHARACTER*1  kdbug,kgau,klandocean
       CHARACTER*10 ksyr,ksmth,ksday,kscy,knfdys
       CHARACTER*10 keyr,kemth,keday,kecy,kicy
       CHARACTER*10 kidim,kjdim,kkpds5,kkpds6,kkpds7,kjcap
       CHARACTER*10 kfactor
c
       dimension deg(jdum), wt(jdum)
c
       call getenv("idbug",kdbug)
       read(kdbug,'(i1)') idbug
       write(*,*) "idbug= ",idbug
c
       call getenv("landocean",klandocean)
       read(klandocean,'(i1)') landocean
       write(*,*) "landocean= ",landocean
c
       call getenv("igau",kgau)
       read(kgau,'(i1)') igau
       write(*,*) "igau= ",igau
C
       call getenv("expname",expname)
       write(*,*) "expname= ",expname
C
       call getenv("maskfile",maskfile)
       write(*,*) "maskfile= ",maskfile
C
       call getenv("var",varname)
       write(*,*) "varname= ",varname
C
       call getenv("plotdatadir",plotdatadir)
       write(*,*) "plotdatadir= ",plotdatadir
C
       call getenv("verfdir",verfdir)
       write(*,*) "verfdir= ",verfdir

       call getenv("clmverf",clmverf)
       write(*,*) "clmverf= ",clmverf

       call getenv("expdir",expdir)
       write(*,*) "expdir= ",expdir

       call getenv("clmexp",clmexp)
       write(*,*) "clmexp= ",clmexp

       call getenv("syear",ksyr)
       read(ksyr,'(I4)') isyr
       write(*,*) "syear= ",isyr
C
       call getenv("smonth",ksmth)
       read(ksmth,'(I2)') ismth
       write(*,*) "smonth= ",ismth
C
       call getenv("sday",ksday)
       read(ksday,'(I2)') isday
       write(*,*) "sday= ",isday
C
       call getenv("shour",kscy)
       read(kscy,'(I2)') iscy
       write(*,*) "shour= ",iscy
C
       call getenv("eyear",keyr)
       read(keyr,'(I4)') ieyr
       write(*,*) "eyear= ",ieyr

       call getenv("emonth",kemth)
       read(kemth,'(I2)') iemth
       write(*,*) "emonth= ",iemth
C
       call getenv("eday",keday)
       read(keday,'(I2)') ieday
       write(*,*) "eday= ",ieday
C
       call getenv("ehour",kecy)
       read(kecy,'(I2)') iecy
       write(*,*) "ehour= ",iecy
c
       call getenv("idim",kidim)
       read(kidim,'(I10)') idim
       write(*,*) "idim= ",idim
c
       call getenv("jdim",kjdim)
       read(kjdim,'(I10)') jdim
       write(*,*) "jdim= ",jdim
c
       call getenv("kpds5",kkpds5)
       read(kkpds5,'(I3)') kpds5
       write(*,*) "kpds5= ",kpds5
c
       call getenv("kpds6",kkpds6)
       read(kkpds6,'(I3)') kpds6
       write(*,*) "kpds6= ",kpds6
c
       call getenv("kpds7",kkpds7)
       read(kkpds7,'(I3)') kpds7
       write(*,*) "kpds7= ",kpds7
c
       call getenv("jcap",kjcap)
       read(kjcap,'(I3)') jcap
       write(*,*) "jcap= ",jcap
c
       call getenv("nfdys",knfdys)
       read(knfdys,'(I2)') nfdys
       write(*,*) "nfdys= ",nfdys
c
       call getenv("factor",kfactor)
       read(kfactor,'(F10.2)') factor
       write(*,*) "factor= ",factor
c
       if(igau.eq.1) then
         call splat(4,jdim,deg,wt)
         pi    = 4.0 * atan(1.0)
         pifac = 180.0 / pi
         do j=1,jdim
           deg(j) = pifac * asin(deg(j))
         enddo
       else
         dlat = 180.0 / float(jdim-1)
         do j=1,jdim
           deg(j)=90.-float(j-1)*dlat
         enddo
       endif
c
c.. get number of cases...
       ncns  = iw3jdn(isyr,ismth,isday)
       ncne  = iw3jdn(ieyr,iemth,ieday)
       ndays = ncne - ncns + 1
       print *,' ncns ',ncns,' ncne ',ncne,' ndays ',ndays
       icases=0
       do ncn=ncns,ncne
        call w3fs26(ncn,iyr,imth,iday,idaywk,idayyr)
        if((imth.ge.3).and.(imth.le.5)) then
         if((iday.eq.1).or.(iday.eq.15)) then
          icases=icases+1
          print *,'icase= ',icases,' iyr= ',iyr,' imth= ',imth,
     *            ' iday= ',iday
         endif
        endif
       enddo
       print *,' icases for MAM ',icases

       call avg(idim,jdim,verfdir,clmverf,
     * expdir,clmexp,expname,varname,plotdatadir,maskfile,
     * isyr,ismth,isday,iscy,ieyr,iemth,ieday,iecy,factor,
     * igau,idbug,landocean,deg,kpds5,kpds6,kpds7,jcap,nfdys,icases)
c
       stop
       end
       subroutine avg(idim,jdim,verfdir,clmverf,
     * expdir,clmexp,expname,varname,plotdatadir,maskfile,
     * isyr,ismth,isday,iscy,ieyr,iemth,ieday,iecy,factor,
     * igau,idbug,landocean,deg,kpds5,kpds6,kpds7,jcap,nfdys,icases)
c
       parameter(nbox=6)
       CHARACTER*200 expname,rname,pname,varname
       CHARACTER*200 verfdir,clmverf
       CHARACTER*200 expdir,clmexp,plotdatadir
       CHARACTER*200 maskfile
       CHARACTER*200 verfgrb,verfind,verfclm,verfclmind
       CHARACTER*200 expgrb,expind,expclm,expclmind
       CHARACTER*200 clmdir,clmfile

       CHARACTER*4  LABY
       CHARACTER*2  LABM(12)
       CHARACTER*2  LABD(31)
       CHARACTER*2  LABC(0:23)

       real gridv(idim,jdim),climv(idim,jdim),climvt(idim,jdim,nfdys)
       real gridu(idim,jdim),climu(idim,jdim),climut(idim,jdim,nfdys)

       real grid(idim,jdim),gridm(idim,jdim),gridma(idim,jdim)

       real acloco(idim,jdim)
       real anom(idim,jdim),anom1(idim,jdim),anomsec(idim,jdim)

       real deg(jdim),cosl(jdim)
       dimension wt(2000)
c*  n*24 cases (twice a month for n years), 6 spheres+boxes, 140 6hr leads
c*                                       however, 140 is 35 for daily
      dimension rms(icases,6,35),sx1(icases,6,35),sy1(icases,6,35),
     *cv(icases,6,35)
      dimension crms(icases,6,35),csx1(icases,6,35),csy1(icases,6,35),
     *ccv(icases,6,35)

      real*4 save(idim,jdim,icases,35)
      real*4 savesec(idim,jdim,icases,35)
      real*4 savever(idim,jdim,icases,35)
      real*4 acts(icases,3),cacts(icases,3),res(16),cres(16)
c
       integer KPDS(200),KGDS(200)
       integer JPDS(200),JGDS(200)
       integer isbox(6),iebox(6)
       integer jsbox(6),jebox(6)
       integer lds(5),lde(5)
c
       logical*1 lbms(idim,jdim)
c
       DATA LABC/'00','01','02','03','04','05',
     &           '06','07','08','09','10','11',
     &           '12','13','14','15','16','17',
     &           '18','19','20','21','22','23'/
C
       DATA LABD/'01','02','03','04','05','06','07','08','09','10',
     *           '11','12','13','14','15','16','17','18','19','20',
     *           '21','22','23','24','25','26','27','28','29','30',
     *           '31'/
C
       DATA LABM/'01','02','03','04','05','06','07','08','09','10',
     *           '11','12'/
C
      lds(1)=1
      lde(1)=7!wk1
      lds(2)=8
      lde(2)=14!wk2
      lds(3)=15
      lde(3)=21!wk3
      lds(4)=22
      lde(4)=28!wk4
      lds(5)=15
      lde(5)=28!wk3&4
c... NH (80N-20N)
       isbox(1)=1
       iebox(1)=idim
       jsbox(1)=11
       jsbox(1)=31 ! to not include sea-ice areas
       jebox(1)=74

c... TR (20N-20S)
       isbox(2)=1
       iebox(2)=idim
       jsbox(2)=75
       jebox(2)=116

c... SH (20S-80S)
       isbox(3)=1
       iebox(3)=idim
       jsbox(3)=117
       jebox(3)=181
       jebox(3)=161 ! to not include sea-ice areas

c... GL (90N-90S)
       isbox(4)=1
       iebox(4)=idim
       jsbox(4)=1
       jebox(4)=jdim

c... US..
       isbox(5)=246
       iebox(5)=321
       jsbox(5)=44
       jebox(5)=69

c... Nino3.4..
       isbox(6)=202
       iebox(6)=257
       jsbox(6)=90
       jebox(6)=101

      if(igau.eq.1) then
         call splat(4,jdim,deg,wt)
         pi    = 4.0 * atan(1.0)
         pifac = 180.0 / pi
         do j=1,jdim
           deg(j) = pifac * asin(deg(j))
           cosl(j)=wt(j)! for weighting inside ac(
         enddo
       else
      pi=4.*atan(1.)
      CONV=PI/180.
         dlat = 180.0 / float(jdim-1)
      DO j=1,jdim
         ALAT=90.-FLOAT(j-1)*dlat
         cosl(j)=COS(ALAT*CONV)
      END DO
      endif
c
       ncns  = iw3jdn(isyr,ismth,isday)
       ncne  = iw3jdn(ieyr,iemth,ieday)

       nfhrs=nfdys*24
       iyrc=2012
       icase=0
       icyv=0
       icyd=0
c
c..... read mask..
       print *,'jcap is ',jcap
       print *,maskfile
       call baopenr(10,maskfile,ierr)
       if(ierr.ne.0) then
        print *,'error opening file ',maskfile
        stop
       endif
       do k=1,200
        JPDS(k) = -1
        enddo
       JPDS(5) = 81
       JPDS(6) = 1
       JPDS(7) = 0
       do k=1,200
        JGDS(k) = -1
       enddo
       N=-1
       CALL GETGB(10,0,idim*jdim,N,JPDS,JGDS,
     *            NDATA,KSKP,KPDS,KGDS,LBMS,GRIDM,IRET)
       if(iret.ne.0) then
        print *,' error in GETGB for rc = ',iret, jpds
        print *,' maskfile = ',maskfile
        stop
       endif
       if(idbug.eq.1) then
        print *,gridm(10,10),gridm(100,100),gridm(200,100)
       endif
       do j=44,69
       write(6,777)(nint(gridm(i,j)),i=246,321)
       enddo
777    format(100i1)
       if (landocean.eq.1) then
       gridm=gridm ! choice for land
       else
       gridm=1.-gridm ! choice for ocean
       endif
       gridma=gridm
       do i=2,idim-1
       do j=2,jdim-1
       if (gridm(i,j).gt.0.9)then
       if (gridm(i-1,j).lt.0.1)gridma(i,j)=0.
       if (gridm(i+1,j).lt.0.1)gridma(i,j)=0.
       if (gridm(i,j+1).lt.0.1)gridma(i,j)=0.
       if (gridm(i,j-1).lt.0.1)gridma(i,j)=0.
       endif
       enddo
       enddo
       gridm=gridma
c
       nd=0
       climut=0.
       climvt=0.
c... start initial condition loop..
       do ncn=ncns,ncne ! (Julian days range)
       nd=nd+1

       call w3fs26(ncn,iyr,imth,iday,idaywk,idayyr)
       write(laby,'(i4)') iyr

       if((imth.ge.3).and.(imth.le.5)) then
        if ((iday.eq.1).or.(iday.eq.15)) then

      icase=icase+1
c..  open verf climo file /climate/noscrub/emc.climpara/Suru/validation/climatology/verf/qdoisst/T574/
c..                       qdoisst.T574.02.15.00Z.mean.clim.daily
       verfclm=clmverf(1:nfill(clmverf))//labm(imth)//'.'//labd(iday)//
     * '.00Z.mean.clim.daily'
c      print *,verfclm
       call baopenr(11,verfclm,ierr)
       if(ierr.ne.0) then
        print *,'error opening file ',verfclm
        stop
       endif
       verfclmind=verfclm(1:nfill(verfclm))//'.index'
c      print *,verfclmind
       call baopenr(12,verfclmind,ierr)
       if(ierr.ne.0) then
        print *,'error opening file ',verfclmind
        stop
       endif
c..  open exp climo file
       expclm=clmexp(1:nfill(clmexp))//labm(imth)//'.'//labd(iday)//
     * '.00Z.mean.clim.daily.T126.'//expname(1:nfill(expname))
c      print *,expclm
       call baopenr(15,expclm,ierr)
       if(ierr.ne.0) then
        print *,'error opening file ',expclm
        stop
       endif
       expclmind=expclm(1:nfill(expclm))//'.index'
c      print *,expclmind
       call baopenr(16,expclmind,ierr)
       if(ierr.ne.0) then
        print *,'error opening file ',expclmind
        stop
       endif

c..  open verf data file /climate/noscrub/emc.climpara/Suru/validation/verf/qdoisst/T574/
c..                      qdoisst.T574.20120301.grib
        verfgrb=verfdir(1:nfill(verfdir))//laby//labm(imth)//
     *  labd(iday)//'.grib'
c       print *,verfgrb
        call baopenr(21,verfgrb,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',verfgrb
         stop
        endif
        verfind=verfgrb(1:nfill(verfgrb))//'.index'
c       print *,verfind
        call baopenr(22,verfind,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',verfind
         stop
        endif
c..  open exp data file
        expgrb=expdir(1:nfill(expdir))//laby//labm(imth)//
     *  labd(iday)//'.grib'
c       print *,expgrb
        call baopenr(25,expgrb,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',expgrb
         stop
        endif
        expind=expgrb(1:nfill(expgrb))//'.index'
c       print *,expind
        call baopenr(26,expind,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',expind
         stop
        endif

c... start forecast loop..
c      do ifhr=24,nfhrs-48,24
       do ifhr=24,nfhrs,24
        lead=ifhr/24

         do k=1,200
          JPDS(k) = -1
         enddo
         JPDS(5) = kpds5
         JPDS(6) = kpds6
         JPDS(7) = kpds7
         JPDS(9)  = imth
         JPDS(10) = iday
         JPDS(14) = ifhr
         JPDS(21) = ((iyr-1)/100) + 1
         do k=1,200
          JGDS(k) = -1
         enddo

c...  first get climos for both verf and exp...
          JPDS(8) = mod(iyrc-1,100) + 1
          JPDS(11) = icyv
          N=-1
          CALL GETGB(11,12,idim*jdim,N,JPDS,JGDS,
     *               NDATA,KSKP,KPDS,KGDS,LBMS,CLIMV,IRET)
          if(iret.ne.0) then
           print *,' error in GETGB for rc = ',iret, jpds
           print *,' verfclm = ',verfclm
           stop
          endif
      do i=1,idim
      do j=1,jdim
      if (lbms(i,j).eq..false.)gridm(i,j)=0.
      enddo
      enddo
          JPDS(11) = icyd
          N=-1
c
         climu=0.
         do idum=-18,0,6
c        do idum=-12,6,6
c        do idum=-6,12,6! This needs to be finessed
c        do idum=0,18,6
c        do idum=6,24,6
c        do idum=12,30,6
c* but should be 12Z to 12Z accumulation to match the verf obs
         JPDS(14) = ifhr+idum
          CALL GETGB(15,16,idim*jdim,N,JPDS,JGDS,
     *               NDATA,KSKP,KPDS,KGDS,LBMS,grid,IRET)
          if(iret.ne.0) then
           print *,' error in GETGB for rc = ',iret, jpds
           print *,' expclm = ',expclm
           stop
          endif
         climu=climu+grid/4.
         enddo!idum loop
c
c         CALL GETGB(15,16,idim*jdim,N,JPDS,JGDS,
c    *               NDATA,KSKP,KPDS,KGDS,LBMS,CLIMU,IRET)
c         if(iret.ne.0) then
c          print *,' error in GETGB for rc = ',iret, jpds
c          print *,' expclm = ',expclm
c          stop
c         endif

c...  next get data for both verf and exp...
          JPDS(8) = mod(iyr-1,100) + 1
          JPDS(11) = icyv
         JPDS(14) = ifhr
          N=-1
          CALL GETGB(21,22,idim*jdim,N,JPDS,JGDS,
     *               NDATA,KSKP,KPDS,KGDS,LBMS,GRIDV,IRET)
          if(iret.ne.0) then
           print *,' error in GETGB for rc = ',iret, jpds
           print *,' verfgrb = ',verfgrb
           stop
          endif
      do i=1,idim
      do j=1,jdim
      if (lbms(i,j).eq..false.)gridm(i,j)=0.
      enddo
      enddo
          JPDS(11) = icyd
          N=-1
c
         gridu=0.
         do idum=-18,0,6
c        do idum=-12,6,6
c        do idum=-6,12,6! This needs to be finessed
c        do idum=0,18,6
c        do idum=6,24,6
c        do idum=12,30,6
         JPDS(14) = ifhr+idum
          CALL GETGB(25,26,idim*jdim,N,JPDS,JGDS,
     *               NDATA,KSKP,KPDS,KGDS,LBMS,grid,IRET)
          if(iret.ne.0) then
           print *,' error in GETGB for rc = ',iret, jpds
           print *,' expgrb = ',expgrb
           stop
          endif
         gridu=gridu+grid/4.
         enddo!idum loop
c
c         CALL GETGB(25,26,idim*jdim,N,JPDS,JGDS,
c    *               NDATA,KSKP,KPDS,KGDS,LBMS,GRIDU,IRET)
c         if(iret.ne.0) then
c          print *,' error in GETGB for rc = ',iret, jpds
c          print *,' expgrb = ',expgrb
c          stop
c         endif
c
          CALL GRIDAV(CLIMV,IDIM,JDIM,DEG,GCLIMV)
          CALL GRIDAV(CLIMU,IDIM,JDIM,DEG,GCLIMU)
          CALL GRIDAV(GRIDV,IDIM,JDIM,DEG,GGRIDV)
          CALL GRIDAV(GRIDU,IDIM,JDIM,DEG,GGRIDU)
c         n=0
c         nb=0
c         do i=1,idim
c         do j=1,jdim
c         n=n+1
c         if (climv(i,j).lt.-0.1)nb=nb+1
c         if (gridm(i,j).gt.0.9)then
c         if (climv(i,j).lt.-1.)write(6,783)i,j,gridm(i,j),climv(i,j)
c         if (climu(i,j).lt.-1.)write(6,784)i,j,gridm(i,j),climu(i,j)
c         if (gridv(i,j).lt.-1.)write(6,785)i,j,gridm(i,j),gridv(i,j)
c         if (gridu(i,j).lt.-1.)write(6,786)i,j,gridm(i,j),gridu(i,j)
c         endif
c         if (gridm(i,j).lt.0.1)then
c         if (climv(i,j).gt.0.)write(6,783)i,j,gridm(i,j),climv(i,j)
c         if (climu(i,j).gt.0.)write(6,784)i,j,gridm(i,j),climu(i,j)
c         if (gridv(i,j).gt.0.)write(6,785)i,j,gridm(i,j),gridv(i,j)
c         if (gridu(i,j).gt.0.)write(6,786)i,j,gridm(i,j),gridu(i,j)
c         endif
c         enddo
c         enddo
c         write(6,783)n,nb,float(nb)/float(n)*100.
783       format(1h ,'discr climv',2i5,2f9.5)
784       format(1h ,'discr climu',2i5,2f9.5)
785       format(1h ,'discr gridv',2i5,2f9.5)
786       format(1h ,'discr gridu',2i5,2f9.5)

          climv=climv*factor
          climu=climu*factor
          gridv=gridv*factor
          gridu=gridu*factor
          climvt(:,:,lead)=climvt(:,:,lead)+climv(:,:)
          climut(:,:,lead)=climut(:,:,lead)+climu(:,:)

          print 111,iyr,imth,iday,icase,lead,ifhr,gclimv,gclimu,
     *    ggridv,ggridu

c* clim is climatologies, grid are frcst or verification
c* v=verification,u=experiment(exp)

          anom1=gridv-climv
          anom=gridu-climv!exp raw
          anomsec=gridu-climu!exp SEC
          if (lead.le.35)save(:,:,icase,lead)=anom(:,:)
          if (lead.le.35)savever(:,:,icase,lead)=anom1(:,:)
          if (lead.le.35)savesec(:,:,icase,lead)=anomsec(:,:)
c* 1,70=NH; 71,111=TR; 112,181=SH for 1x1 grid
          do ib=1,3! here ib is also ihemi
          is=isbox(ib)
          ie=iebox(ib)
          js=jsbox(ib)
          je=jebox(ib)
          x=ac(anom,anom1,cosl,idim,jdim,1.,is,ie,js,je,
     *cov,sx,sy,r,lead,gridm)
          rms(icase,ib,lead)=r
          sx1(icase,ib,lead)=sx
          sy1(icase,ib,lead)=sy
          cv(icase,ib,lead)=cov
          x=ac(anomsec,anom1,cosl,idim,jdim,1.,is,ie,js,je,
     *cov,sx,sy,r,lead,gridm)
          crms(icase,ib,lead)=r
          csx1(icase,ib,lead)=sx
          csy1(icase,ib,lead)=sy
          ccv(icase,ib,lead)=cov
       enddo! ib(ox) loop

c  end forecast loop
       enddo

        call baclose(11,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',verfclm
         stop
        endif
        call baclose(12,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',verfclmind
         stop
        endif
        call baclose(15,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',expclm
         stop
        endif
        call baclose(16,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',expclmind
         stop
        endif

        call baclose(21,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',verfgrb
         stop
        endif
        call baclose(22,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',verfind
         stop
        endif
        call baclose(25,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',expgrb
         stop
        endif
        call baclose(26,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',expind
         stop
        endif

       endif
      endif

c  end initial condition loop
       enddo
c
      climvt=climvt/float(icases)
       climut=climut/float(icases)
c*undef 9.999E+20
       do i=1,idim
       do j=1,jdim
       do lead=1,nfdys
       if (gridm(i,j).le.0.1)climvt(i,j,lead)=9.999E+20
       if (gridm(i,j).le.0.1)climut(i,j,lead)=9.999E+20
       enddo
       enddo
       enddo
c
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.TMPsfc.seasmean.verf.mam.bin',FORM="unformatted")
      write(12) climvt
      print *,'i am here after verf'
      CLOSE(12)
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.TMPsfc.seasmean.model.mam.bin',FORM="unformatted")
      write(12) climut
      print *,'i am here after model'
      CLOSE(12)

      do ihemi=1,3!NH,TR,SH
C     determine file name properties
      SELECT CASE (ihemi)
        CASE (1)
          rname='NH'
        CASE (2)
          rname='TR'
        CASE (3)
          rname='SH'
        CASE DEFAULT
          PRINT *,'Unknown case. Stop.'
          EXIT
      END SELECT
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.'//rname(1:NFILL(rname))//'.dieoff.daily.mam.txt')
      do lead=1,35
      call talley(rms,sx1,sy1,cv,lead,ihemi
     *,res1,res2,res3,res4,res5,icases)
      call talley(crms,csx1,csy1,ccv,lead,ihemi
     *,cres1,cres2,cres3,cres4,cres5,icases)
       print 112,res1,res2,res3,res5,float(lead),
     *cres1,cres2,cres3,cres5,ihemi
C     write to file
      WRITE(12,112),res1,res2,res3,res5,float(lead),
     *cres1,cres2,cres3,cres5,ihemi
       enddo
       print 112
C     close file
      CLOSE(12)
      enddo 

c         do ib=1,3! here ib is also ihemi
          do ihemiorbox=1,4
          ib=ihemiorbox
      if (ihemiorbox.eq.4)then
      if (landocean.eq.1)ib=5!US box
      if (landocean.eq.0)ib=6!Nino34 box
          info1=landocean
          info2=ib
          endif
          is=isbox(ib)
          ie=iebox(ib)
          js=jsbox(ib)
          je=jebox(ib)
c* wk1 to 4+3&4
      write(6,729)ib,is,ie,js,je,landocean,deg(js),deg(je)
729   format('mam wk1-5 boxnr, four ijboxcorners landocean ',6i8,2f6.1)
      write(6,728)
728   format(1h ,'##########################################')
      do iw=1,5! wk1, 2, 3, 4, and 3&4
      fakave=float(lde(iw)-lds(iw)+1)
      do icase=1,icases
       anom=0.
       anom1=0.
        do lead=lds(iw),lde(iw)
        grid(:,:)=save(:,:,icase,lead)
        anom=anom+grid/fakave
        grid(:,:)=savever(:,:,icase,lead)
        anom1=anom1+grid/fakave
        enddo
          x=ac(anom,anom1,cosl,idim,jdim,1.,is,ie,js,je,
     *    cov,sx,sy,r,lead,gridm)
      if (iw.eq.5.and.ihemiorbox.eq.4)acts(icase,1)=cov
      if (iw.eq.5.and.ihemiorbox.eq.4)acts(icase,2)=sx
      if (iw.eq.5.and.ihemiorbox.eq.4)acts(icase,3)=sy
          rms(icase,ib,iw)=r
          sx1(icase,ib,iw)=sx
          sy1(icase,ib,iw)=sy
          cv(icase,ib,iw)=cov
       anom=0.
        do lead=lds(iw),lde(iw)
        grid(:,:)=savesec(:,:,icase,lead)
        anom=anom+grid/fakave
        enddo
          x=ac(anom,anom1,cosl,idim,jdim,1.,is,ie,js,je,
     *    cov,sx,sy,r,lead,gridm)
      if (iw.eq.5.and.ihemiorbox.eq.4)cacts(icase,1)=cov
      if (iw.eq.5.and.ihemiorbox.eq.4)cacts(icase,2)=sx
      if (iw.eq.5.and.ihemiorbox.eq.4)cacts(icase,3)=sy
          crms(icase,ib,iw)=r
          csx1(icase,ib,iw)=sx
          csy1(icase,ib,iw)=sy
          ccv(icase,ib,iw)=cov
      enddo
      enddo! iw(eek) loop
      enddo! ib(ox) loop
c
c     do ihemi=1,1!NH
          do ihemiorbox=1,4
          ib=ihemiorbox
      if (ihemiorbox.eq.4)then
      if (landocean.eq.1)ib=5!US box
      if (landocean.eq.0)ib=6!Nino34 box
          endif
          ihemi=ib    
       do lead=1,5
       SELECT CASE (ib)
        CASE (1)
          rname='NH'
        CASE (2)
          rname='TR'
        CASE (3)
          rname='SH'
        CASE (5)
          rname='US'
        CASE (6)
          rname='NINO3p4'
        CASE DEFAULT
          PRINT *,'Unknown case. Stop.'
          EXIT
       END SELECT
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.'//rname(1:NFILL(rname))//
     * '.dieoff.average.mam.txt')
      call talley(rms,sx1,sy1,cv,lead,ihemi
     *,res1,res2,res3,res4,res5,icases)
      call talley(crms,csx1,csy1,ccv,lead,ihemi
     *,cres1,cres2,cres3,cres4,cres5,icases)
       print 112,res1,res2,res3,res5,float(lead),
     *cres1,cres2,cres3,cres5,ihemi
C     write to file
      WRITE(12,112),res1,res2,res3,res5,float(lead),
     *cres1,cres2,cres3,cres5,ihemi
       enddo
       print 112
C     close file
      CLOSE(12)
      enddo

c    open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.'//rname(1:NFILL(rname))//
     * '.actimeseries.mam.txt')
       write(12,732)
       write(12,733)info1,info2
733   format(1h ,'landocean and boxnr ',2i7)
       write(12,732)
     *(100.*acts(icase,1)/(acts(icase,2)*acts(icase,3)),icase=1,icases)
       write(12,732)
       write(12,732)
     *(100.*cacts(icase,1)/(cacts(icase,2)*cacts(icase,3)),
     * icase=1,icases)
C     close file
      CLOSE(12)
c
       x=0.
       y=0.
       z=0.
       do ind=1,icases
       z=z+acts(ind,1)
       x=x+acts(ind,2)*acts(ind,2)
       y=y+acts(ind,3)*acts(ind,3)
       enddo
       ag144=100.*z/sqrt(x*y)
c
       x=0.
       y=0.
       z=0.
       do ind=1,icases
       z=z+cacts(ind,1)
       x=x+cacts(ind,2)*cacts(ind,2)
       y=y+cacts(ind,3)*cacts(ind,3)
       enddo
       cag144=100.*z/sqrt(x*y)
c
       do m=4,15
       x=0.
       y=0.
       z=0.
       do j=1,6
       i=(m-3)*2
       ind2=(j-1)*24+i
       ind1=ind2-1
       z=z+acts(ind1,1)+acts(ind2,1)
       x=x+acts(ind1,2)*acts(ind1,2)+acts(ind2,2)*acts(ind2,2)
       y=y+acts(ind1,3)*acts(ind1,3)+acts(ind2,3)*acts(ind2,3)
       enddo
       res(m)=100.*z/sqrt(x*y)
       x=0.
       y=0.
       z=0.
       do j=1,6
       i=(m-3)*2
       ind2=(j-1)*24+i
       ind1=ind2-1
       z=z+cacts(ind1,1)+cacts(ind2,1)
       x=x+cacts(ind1,2)*cacts(ind1,2)+cacts(ind2,2)*cacts(ind2,2)
       y=y+cacts(ind1,3)*cacts(ind1,3)+cacts(ind2,3)*cacts(ind2,3)
       enddo
       cres(m)=100.*z/sqrt(x*y)
       enddo
       do im=1,3
       res(im)=res(im+12)
       cres(im)=cres(im+12)
       enddo
       x=0.
       y=0.
       do im=1,12
       x=x+res(im)/12.
       y=y+cres(im)/12.
       enddo
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.'//rname(1:NFILL(rname))//
     * '.acmonthly.mam.txt')
       write(12,733)info1,info2
       write(12,734)(res(im),im=1,12),x
       write(12,734)(cres(im),im=1,12),y
C     close file
      CLOSE(12)
      write(6,728)
      write(6,735)x,ag144
      write(6,736)y,cag144
735   format('MAM RAW average of 12',f7.1,'  aggregate of icases',f7.1)
736   format('MAM SEC average of 12',f7.1,'  aggregate of icases',f7.1)

C     acloc for weeks 1, 2, 3, 4, 3&4
C wk1
      call loccor(save,savever,cosl,idim,jdim,17,1,acloco,icases,gridm)
      print *,'wk1.raw.mam.ac'
c     do j=44,69,2
c      write(6,277)deg(j),(acloco(i,j),i=246,321,3)
c     enddo
      do j=1,74,3
       write(6,277)deg(j),(gridm(i,j),i=1,idim,12)
      enddo
      do j=1,74,3
       write(6,277)deg(j),(acloco(i,j),i=1,idim,12)
      enddo
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.wk1.raw.mam.ac',FORM="unformatted")
C    write to file
      WRITE(12)(acloco)
C     close file
      CLOSE(12)

      call loccor(savesec,savever,cosl,idim,jdim,18,1,acloco,icases,
     * gridm)
      print *,'wk1.sec.mam.ac'
      do j=1,74,3
       write(6,277)deg(j),(acloco(i,j),i=1,idim,12)
      enddo
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.wk1.sec.mam.ac',FORM="unformatted")
C    write to file
      WRITE(12)(acloco)
C     close file
      CLOSE(12)

C wk2
      call loccor(save,savever,cosl,idim,jdim,17,2,acloco,icases,gridm)
      print *,'wk2.raw.mam.ac'
      do j=1,74,3
       write(6,277)deg(j),(acloco(i,j),i=1,idim,12)
      enddo
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.wk2.raw.mam.ac',FORM="unformatted")
C    write to file
      WRITE(12)(acloco)
C     close file
      CLOSE(12)

      call loccor(savesec,savever,cosl,idim,jdim,18,2,acloco,icases,
     *gridm)
      print *,'wk2.sec.mam.ac'
      do j=1,74,3
       write(6,277)deg(j),(acloco(i,j),i=1,idim,12)
      enddo
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.wk2.sec.mam.ac',FORM="unformatted")
C    write to file
      WRITE(12)(acloco)
C     close file
      CLOSE(12)

C wk3
      call loccor(save,savever,cosl,idim,jdim,17,3,acloco,icases,gridm)
      print *,'wk3.raw.mam.ac'
      do j=1,74,3
       write(6,277)deg(j),(acloco(i,j),i=1,idim,12)
      enddo
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.wk3.raw.mam.ac',FORM="unformatted")
C    write to file
      WRITE(12)(acloco)
C     close file
      CLOSE(12)

      call loccor(savesec,savever,cosl,idim,jdim,18,3,acloco,icases,
     *gridm)
      print *,'wk3.sec.mam.ac'
      do j=1,74,3
       write(6,277)deg(j),(acloco(i,j),i=1,idim,12)
      enddo
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.wk3.sec.mam.ac',FORM="unformatted")
C    write to file
      WRITE(12)(acloco)
C     close file
      CLOSE(12)

C wk4
      call loccor(save,savever,cosl,idim,jdim,17,4,acloco,icases,gridm)
      print *,'wk4.raw.mam.ac'
      do j=1,74,3
       write(6,277)deg(j),(acloco(i,j),i=1,idim,12)
      enddo
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.wk4.raw.mam.ac',FORM="unformatted")
C    write to file
      WRITE(12)(acloco)
C     close file
      CLOSE(12)

      call loccor(savesec,savever,cosl,idim,jdim,18,4,acloco,icases,
     *gridm)
      print *,'wk4.sec.mam.ac'
      do j=1,74,3
       write(6,277)deg(j),(acloco(i,j),i=1,idim,12)
      enddo
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.wk4.sec.mam.ac',FORM="unformatted")
C    write to file
      WRITE(12)(acloco)
C     close file
      CLOSE(12)

C wk4
      call loccor(save,savever,cosl,idim,jdim,17,34,acloco,icases,gridm)
      print *,'wk34.raw.mam.ac'
      do j=1,74,3
       write(6,277)deg(j),(acloco(i,j),i=1,idim,12)
      enddo
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.wk34.raw.mam.ac',FORM="unformatted")
C    write to file
      WRITE(12)(acloco)
C     close file
      CLOSE(12)

      call loccor(savesec,savever,cosl,idim,jdim,18,34,acloco,icases,
     *gridm)
      print *,'wk34.sec.mam.ac'
      do j=1,74,3
       write(6,277)deg(j),(acloco(i,j),i=1,idim,12)
      enddo
C     open file to write
      OPEN(UNIT=12,FILE=plotdatadir(1:NFILL(plotdatadir))
     * //'/'//expname(1:NFILL(expname))
     * //'.'//varname(1:NFILL(varname))
     * //'.wk34.sec.mam.ac',FORM="unformatted")
C    write to file
      WRITE(12)(acloco)
C     close file
      CLOSE(12)

277    format(f4.1,32f4.0)
732   format(24f5.1)
734   format(12f7.1,'   ave12',f8.1)
 111   format(6i5,2x,6f10.2)
 112   format(4f7.2,f7.2,4f7.2,i4)
         return
         end
c
      function ac(anom,anom1,cosl,im,jm,fak,
     *ib,ie,lb,le,cov,sx,sy,r,ip,gridm)
      dimension anom(im,jm),cosl(jm)
      dimension anom1(im,jm),gridm(im,jm)
      x=0.
      y=0.
      avx=0.
      avy=0.
      z=0.
      r=0.
      zz=0.
      do jlat=lb,le
      w=cosl(jlat)
      do i=ib,ie
      if (gridm(i,jlat).gt.0.9)then
      ax=anom(i,jlat)/fak
      ay=anom1(i,jlat)/fak
      avx=avx+ax*w
      avy=avy+ay*w
      x=x+(ax*ax)*w
      y=y+(ay*ay)*w
      z=z+(ay*ax)*w
      r=r+(ay-ax)*(ay-ax)*w
      zz=zz+w
      endif
      enddo
      enddo
      sx=0.00000001
      sy=0.00000001
      if (x.gt.0.) sx=sqrt(x/zz)
      if (y.gt.0.) sy=sqrt(y/zz)
      if (r.gt.0.) r=sqrt(r/zz)
      ac=z/zz/sx/sy
      cov=z/zz
      avx=avx/zz
      avy=avy/zz
c     if (ip.eq.1)write(6,101)avx,avy,sx,sy,ac*100.,lb,le,r,zz
101   format(1h ,'inside ac:',5f10.1,2i4,2f10.1)
      return
      end
c
      subroutine talley(rms,sx1,sy1,cv,lead,ihemi
     *,res1,res2,res3,res4,res5,icases)
      dimension rms(icases,6,35),sx1(icases,6,35),sy1(icases,6,35),
     *cv(icases,6,35)
       av1=0.
       av2=0.
       av3=0.
       av4=0.
       n=0
       do icase=1,icases
       r=rms(icase,ihemi,lead)
       sx=sx1(icase,ihemi,lead)
       sy=sy1(icase,ihemi,lead)
       c=cv(icase,ihemi,lead)
       av1=av1+r*r
       av2=av2+sx*sx
       av3=av3+sy*sy
       av4=av4+c
       n=n+1
       enddo
       res1=sqrt(av1/float(n))
       res2=sqrt(av2/float(n))
       res3=sqrt(av3/float(n))
       res4=av4/float(n)
       res5=res4/(res2*res3)*100.
      return
      end
c
      subroutine loccor(save,savever,cosl,idim,jdim,idch,week,acloc,
     *icases,gridm)
      real*4 save(idim,jdim,icases,35),cosl(jdim),gridm(idim,jdim)
      real*4 savever(idim,jdim,icases,35)
      real*4 rms(idim,jdim),sx(idim,jdim),sy(idim,jdim),cov(idim,jdim)
      real*4 r(idim,jdim),x(idim,jdim),y(idim,jdim),acloc(idim,jdim)
      integer*4 week

       fcases=float(icases)

      SELECT CASE (week)
        CASE (1)
c*      wk1:
        rms=0.
        sx=0.
        sy=0.
        cov=0.
        fak=7.*fcases
        do icase=1,icases
        do lead=1,7
        x(:,:)=save(:,:,icase,lead)
        y(:,:)=savever(:,:,icase,lead)
        r=x-y
        rms=rms+r*r/fak
        sx=sx+x*x/fak
        sy=sy+y*y/fak
        cov=cov+x*y/fak
        enddo
        enddo
        sx=sqrt(sx)
        sy=sqrt(sy)
        rms=sqrt(rms)
        acloc=100.*cov/(sx*sy)
c      write(idch)acloc
c      write(6,100)rms(1,40),sx(1,40),sy(1,40),acloc(1,40)    
c     call uslandave(gridm,idim,jdim,sx,sy,cov,rms,cosl,1,7)

        CASE (2)
c*      wk2:
        rms=0.
        sx=0.
        sy=0.
        cov=0.
        fak=7.*fcases
        do icase=1,icases
        do lead=8,14
        x(:,:)=save(:,:,icase,lead)
        y(:,:)=savever(:,:,icase,lead)
        r=x-y
        rms=rms+r*r/fak
        sx=sx+x*x/fak
        sy=sy+y*y/fak
        cov=cov+x*y/fak
        enddo
        enddo
        sx=sqrt(sx)
        sy=sqrt(sy)
        rms=sqrt(rms)
        acloc=100.*cov/(sx*sy)
c      write(idch)acloc
c      write(6,100)rms(1,40),sx(1,40),sy(1,40),acloc(1,40)
c     call uslandave(gridm,idim,jdim,sx,sy,cov,rms,cosl,8,14)
          
        CASE (3)
c*      wk3:
        rms=0.
        sx=0.
        sy=0.
        cov=0.
        fak=7.*fcases
        do icase=1,icases
        do lead=15,21
        x(:,:)=save(:,:,icase,lead)
        y(:,:)=savever(:,:,icase,lead)
        r=x-y
        rms=rms+r*r/fak
        sx=sx+x*x/fak
        sy=sy+y*y/fak
        cov=cov+x*y/fak
        enddo
        enddo
        sx=sqrt(sx)
        sy=sqrt(sy)
        rms=sqrt(rms)
        acloc=100.*cov/(sx*sy)
c      write(idch)acloc
c      write(6,100)rms(1,40),sx(1,40),sy(1,40),acloc(1,40)
c     call uslandave(gridm,idim,jdim,sx,sy,cov,rms,cosl,15,21)

        CASE (4)
c*      wk4:
        rms=0.
        sx=0.
        sy=0.
        cov=0.
        fak=7.*fcases
        do icase=1,icases
        do lead=22,28
        x(:,:)=save(:,:,icase,lead)
        y(:,:)=savever(:,:,icase,lead)
        r=x-y
        rms=rms+r*r/fak
        sx=sx+x*x/fak
        sy=sy+y*y/fak
        cov=cov+x*y/fak
        enddo
        enddo
        sx=sqrt(sx)
        sy=sqrt(sy)
        rms=sqrt(rms)
        acloc=100.*cov/(sx*sy)
c      write(idch)acloc
c      write(6,100)rms(1,40),sx(1,40),sy(1,40),acloc(1,40)
c     call uslandave(gridm,idim,jdim,sx,sy,cov,rms,cosl,22,28)
       
        CASE (34)
c*      wk3&4:
        rms=0.
        sx=0.
        sy=0.
        cov=0.
        fak=14.*fcases
        do icase=1,icases
        do lead=15,28
        x(:,:)=save(:,:,icase,lead)
        y(:,:)=savever(:,:,icase,lead)
        r=x-y
        rms=rms+r*r/fak
        sx=sx+x*x/fak
        sy=sy+y*y/fak
        cov=cov+x*y/fak
        enddo
        enddo
        sx=sqrt(sx)
        sy=sqrt(sy)
        rms=sqrt(rms)
        acloc=100.*cov/(sx*sy)
c      write(idch)acloc
c      write(6,100)rms(1,40),sx(1,40),sy(1,40),acloc(1,40)   
c     call uslandave(gridm,idim,jdim,sx,sy,cov,rms,cosl,15,28)
        CASE DEFAULT
          PRINT *,'Unknown week.'
      END SELECT

c100   format(1h ,'loc ac:',5f10.1)
      return
      end
c
      subroutine uslandave(gridm,idim,jdim,sx,sy,cov,rms,cosl,l1,l2)
      real*4 gridm(idim,jdim),sx(idim,jdim),sy(idim,jdim)
      real*4 rms(idim,jdim),cov(idim,jdim),cosl(jdim)
       x=0.
       y=0.
       c=0.
       w=0.
       r=0.
       do j=44,69
       do i=246,321
       if (gridm(i,j).gt.0.9)x=x+sx(i,j)*sx(i,j)*cosl(j)
       if (gridm(i,j).gt.0.9)y=y+sy(i,j)*sy(i,j)*cosl(j)
       if (gridm(i,j).gt.0.9)c=c+cov(i,j)*cosl(j)
       if (gridm(i,j).gt.0.9)r=r+rms(i,j)*rms(i,j)*cosl(j)
       if (gridm(i,j).gt.0.9)w=w+cosl(j)
       enddo
       enddo
       x=sqrt(x/w)
       y=sqrt(y/w)
       r=sqrt(r/w)
       acl=c/w/(x*y)*100.
       write(6,100)l1,l2,r,x,y,acl,w
100    format(1h ,'us-land-ave: ',2i5,5f10.2)
      return
      end
