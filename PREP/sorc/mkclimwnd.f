       parameter(jdum=2000)
       CHARACTER*200 grbdir,clmdir,expname
       CHARACTER*1  kdbug,kgau
       CHARACTER*10 ksyr,ksmth,ksday,kscy,knfdys
       CHARACTER*10 keyr,kemth,keday,kecy,kicy
       CHARACTER*10  kidim,kjdim,kkpds5u,kkpds5v,kkpds6,kkpds7
       CHARACTER*10  hgrid
c
       dimension deg(jdum), wt(jdum)
c
       call getenv("idbug",kdbug)
       read(kdbug,'(i1)') idbug
       write(*,*) "idbug= ",idbug
c
       call getenv("igau",kgau)
       read(kgau,'(i1)') igau
       write(*,*) "igau= ",igau
C
       call getenv("hgrid",hgrid)
       write(*,*) "hgrid= ",hgrid

       call getenv("grbdir",grbdir)
       write(*,*) "grbdir= ",grbdir

       call getenv("clmdir",clmdir)
       write(*,*) "clmdir= ",clmdir

       call getenv("expname",expname)
       write(*,*) "expname= ",expname

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
       call getenv("kpds5u",kkpds5u)
       read(kkpds5u,'(I3)') kpds5u
       write(*,*) "kpds5u= ",kpds5u
c
       call getenv("kpds5v",kkpds5v)
       read(kkpds5v,'(I3)') kpds5v
       write(*,*) "kpds5v= ",kpds5v
c
       call getenv("kpds6",kkpds6)
       read(kkpds6,'(I3)') kpds6
       write(*,*) "kpds6= ",kpds6
c
       call getenv("kpds7",kkpds7)
       read(kkpds7,'(I3)') kpds7
       write(*,*) "kpds7= ",kpds7
c
       call getenv("nfdys",knfdys)
       read(knfdys,'(I2)') nfdys
       write(*,*) "nfdys= ",nfdys
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
       call avg(idim,jdim,grbdir,clmdir,nfdys,
     * isyr,ismth,isday,iscy,ieyr,iemth,ieday,iecy,
     * igau,idbug,deg,kpds5u,kpds5v,kpds6,kpds7,hgrid,expname)
c
       stop
       end
       subroutine avg(idim,jdim,grbdir,clmdir,nfdys,
     * isyr,ismth,isday,iscy,ieyr,iemth,ieday,iecy,
     * igau,idbug,deg,kpds5u,kpds5v,kpds6,kpds7,hgrid,expname)
c
       CHARACTER*200 grbdir,grbfile,indfile,expname
       CHARACTER*200 clmdir,clmfile
       CHARACTER*10  hgrid

       CHARACTER*4  LABY
       CHARACTER*2  LABM(12)
       CHARACTER*2  LABD(31)
       CHARACTER*2  LABC(0:23)

       real gridu(idim,jdim),climu(idim,jdim)
       real annmeanu(idim,jdim,nfdys*4)
       real au(idim,jdim,nfdys*4,4),bu(idim,jdim,nfdys*4,4)
       real gridv(idim,jdim),climv(idim,jdim)
       real annmeanv(idim,jdim,nfdys*4)
       real av(idim,jdim,nfdys*4,4),bv(idim,jdim,nfdys*4,4)

       real deg(jdim)
c
       integer KPDS(200),KGDS(200)
       integer JPDS(200),JGDS(200)
       integer ncase(0:nfdys*4)
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
       ncns  = iw3jdn(isyr,ismth,isday)
       ncne  = iw3jdn(ieyr,iemth,ieday)

       PI=4.*ATAN(1.)
       period=365.24219
       OMEGA=2.0*PI/period

        nfhrs=nfdys*24

c... start cycle loop..
       do ncy=ncys,ncye,6
       annmean=0.
       ncase=0
C
c... start initial condition loop..
       do ncn=ncns,ncne ! (Julian days range)
       call w3fs26(ncn,iyr,imth,iday,idaywk,idayyr)
       write(laby,'(i4)') iyr

       if ((iday.eq.1).or.(iday.eq.15)) then
C
        grbfile=grbdir(1:nfill(grbdir))//laby//labm(imth)//
     *  labd(iday)//'.grib'
        print *,grbfile
        call baopenr(11,grbfile,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',grbfile
         stop
        endif
        indfile=grbfile(1:nfill(grbfile)) // '.index'
        call baopenr(12,indfile,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',indfile
         stop
        endif

c... start forecast loop..
       do ifhr=6,nfhrs,6
       lead=ifhr/6
c
         do k=1,200
          JPDS(k) = -1
         enddo
         JPDS(6) = kpds6
         JPDS(7) = kpds7
         JPDS(8) = mod(IYR-1,100) + 1
         JPDS(9)  = IMTH
         JPDS(10) = IDAY
         JPDS(11) = ICY
         JPDS(14) = IFHR
         JPDS(21) = ((IYR-1)/100) + 1
         do k=1,200
          JGDS(k) = -1
         enddo
c
c..  first read u-component..
         JPDS(5) = kpds5u
         N=-1
         CALL GETGB(11,12,idim*jdim,N,JPDS,JGDS,
     *              NDATA,KSKP,KPDS,KGDS,LBMS,GRIDU,IRET)
         if(iret.ne.0) then
          print *,' error in GETGB for rc = ',iret, jpds
          stop
         endif
c..  next read v-component..
         JPDS(5) = kpds5v
         N=-1
         CALL GETGB(11,12,idim*jdim,N,JPDS,JGDS,
     *              NDATA,KSKP,KPDS,KGDS,LBMS,GRIDV,IRET)
         if(iret.ne.0) then
          print *,' error in GETGB for rc = ',iret, jpds
          stop
         endif
c
         if(idbug.eq.1) then
          CALL GRIDAV(GRIDU,IDIM,JDIM,DEG,GLOBU)
          CALL GRIDAV(GRIDV,IDIM,JDIM,DEG,GLOBV)
          print *,iyr,imth,iday,icy,ifhr,globu,globv
         endif

         if (lead.gt.0) then
          annmeanu(:,:,lead)=annmeanu(:,:,lead)+gridu(:,:)
          annmeanv(:,:,lead)=annmeanv(:,:,lead)+gridv(:,:)
          ncase(lead)=ncase(lead)+1
         endif

c  end forecast loop
       enddo

        call baclose(11,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',grbfile
         stop
        endif
        call baclose(12,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',indfile
         stop
        endif

       endif

c  end initial condition loop
       enddo
c
       do lead=1,nfdys*4
        annmeanu(:,:,lead)=annmeanu(:,:,lead)/float(ncase(lead))
        gridu(:,:)=annmeanu(:,:,lead)
c       write(21)gridu
        annmeanv(:,:,lead)=annmeanv(:,:,lead)/float(ncase(lead))
        gridv(:,:)=annmeanv(:,:,lead)
c       write(21)gridv
        print *,lead,ncase(lead),gridu(290,56),gridv(290,56)
       enddo

c  end cycle loop
       enddo
c
c----2nd cycle loop to estimate the a's and b's
       do ncy=ncys,ncye,6

       a=0.
       b=0.
       ncase=0
       nd=0
c... start initial condition loop..
       do ncn=ncns,ncne ! (Julian days range)

       nd=nd+1
       call w3fs26(ncn,iyr,imth,iday,idaywk,idayyr)
       write(laby,'(i4)') iyr

       if ((iday.eq.1).or.(iday.eq.15)) then
c
        grbfile=grbdir(1:nfill(grbdir))//laby//labm(imth)//
     *  labd(iday)//'.grib'
        call baopenr(11,grbfile,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',grbfile
         stop
        endif
        indfile=grbfile(1:nfill(grbfile)) // '.index'
        call baopenr(12,indfile,ierr)
        if(ierr.ne.0) then
         print *,'error opening file ',indfile
         stop
        endif

c... start forecast loop..
       do ifhr=6,nfhrs,6
       lead=ifhr/6
c
         do k=1,200
          JPDS(k) = -1
         enddo
         JPDS(6) = kpds6
         JPDS(7) = kpds7
         JPDS(8) = mod(IYR-1,100) + 1
         JPDS(9)  = IMTH
         JPDS(10) = IDAY
         JPDS(11) = ICY
c        JPDS(13) = 1
         JPDS(14) = IFHR
         JPDS(21) = ((IYR-1)/100) + 1
         do k=1,200
          JGDS(k) = -1
         enddo
c
c... first read u-component..
         JPDS(5) = kpds5u
         N=-1
         CALL GETGB(11,12,idim*jdim,N,JPDS,JGDS,
     *              NDATA,KSKP,KPDS,KGDS,LBMS,GRIDU,IRET)
         if(iret.ne.0) then
          print *,' error in GETGB for rc = ',iret, jpds
          stop
         endif
c... next read v-component..
         JPDS(5) = kpds5v
         N=-1
         CALL GETGB(11,12,idim*jdim,N,JPDS,JGDS,
     *              NDATA,KSKP,KPDS,KGDS,LBMS,GRIDV,IRET)
         if(iret.ne.0) then
          print *,' error in GETGB for rc = ',iret, jpds
          stop
         endif
c
         if(idbug.eq.1) then
          CALL GRIDAV(GRIDU,IDIM,JDIM,DEG,GLOBU)
          CALL GRIDAV(GRIDV,IDIM,JDIM,DEG,GLOBV)
          print *,iyr,imth,iday,icy,ifhr,globu,globv
         endif
c
         if (lead.gt.0)then
          gridu(:,:)=gridu(:,:)-annmeanu(:,:,lead)
          gridv(:,:)=gridv(:,:)-annmeanv(:,:,lead)
          do itone=1,4  ! 4 is a choice
           ANGLE = FLOAT(nd) * OMEGA*float(itone)
           FAKC = COS(ANGLE)
           FAKs = SIN(ANGLE)
           au(:,:,lead,itone)=au(:,:,lead,itone)+gridu(:,:)*faks
           bu(:,:,lead,itone)=bu(:,:,lead,itone)+gridu(:,:)*fakc
           av(:,:,lead,itone)=av(:,:,lead,itone)+gridv(:,:)*faks
           bv(:,:,lead,itone)=bv(:,:,lead,itone)+gridv(:,:)*fakc
          enddo
          ncase(lead)=ncase(lead)+1
         endif
c
c  end forecast loop
       enddo

        call baclose(11,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',grbfile
         stop
        endif
        call baclose(12,ierr)
        if(ierr.ne.0) then
         print *,'error closing file ',indfile
         stop
        endif

       endif

c  end initial condition loop
       enddo
c
       do lead=1,nfdys*4
        au(:,:,lead,:)=2.*au(:,:,lead,:)/float(ncase(lead))
        bu(:,:,lead,:)=2.*bu(:,:,lead,:)/float(ncase(lead))
        av(:,:,lead,:)=2.*av(:,:,lead,:)/float(ncase(lead))
        bv(:,:,lead,:)=2.*bv(:,:,lead,:)/float(ncase(lead))
        print *,lead,ncase(lead),au(290,56,lead,1),bu(290,56,lead,1),
     *  av(290,56,lead,1),bv(290,56,lead,1)
       enddo

c  end cycle loop
       enddo

c.. now write out the climos..

         iyrc=2012
         ismthc=1
         isdayc=1
         iemthc=12
         iedayc=31

         icyc=0
         ncnsc  = iw3jdn(iyrc,ismthc,isdayc)
         ncnec  = iw3jdn(iyrc,iemthc,iedayc)

         kpdsx=kpds(22)+2
         do ncnc=ncnsc,ncnec ! (set the 366 Julian days range for generic year 2012) initial times
          call w3fs26(ncnc,iyrc,imthc,idayc,idaywk,idayyr)

          if((idayc.eq.1).or.(idayc.eq.15))then

c          /climate/noscrub/emc.climpara/Suru/validation/climatology/UGCSbench_mom6/wnd200/wnd200.
c          12.15.00Z.mean.clim.daily.1x1.UGCSbench_mom6

           clmfile=clmdir(1:nfill(clmdir))//labm(imthc)//'.'//
     *     labd(idayc)//'.'//labc(icyc)//'Z.mean.clim.daily.'//
     *     hgrid(1:nfill(hgrid))//'.'//expname(1:nfill(expname))
           print *,'clmfile ',clmfile
           call baopenwt(71,clmfile,ierr)
           if(ierr.ne.0) then
            print *,'error opening file ',clmfile
            stop
           endif

           lead=0
           do id=1,nfdys*4
            lead=lead+1
            ifhr=lead*6

          call recoclimo(annmeanu,au,bu,lead,climu,idim,jdim,ncnc,nfdys)
          call recoclimo(annmeanv,av,bv,lead,climv,idim,jdim,ncnc,nfdys)

            KPDS(8) = mod(iyrc-1,100) + 1
            KPDS(9)  = imthc
            KPDS(10) = idayc
            KPDS(11) = icyc
            KPDS(14) = IFHR
            KPDS(22) = kpdsx
            KPDS(21) = ((iyrc-1)/100) + 1
c
c.... first write out u-component
            KPDS(5)  = kpds5u
            CALL PUTGB(71,NDATA,KPDS,KGDS,LBMS,climu,IRET)
            if(iret.ne.0) then
             print *,nr,' error in PUTGB for iret ',iret
             stop
            endif
c.... next write out v-component
            KPDS(5)  = kpds5v
            CALL PUTGB(71,NDATA,KPDS,KGDS,LBMS,climv,IRET)
            if(iret.ne.0) then
             print *,nr,' error in PUTGB for iret ',iret
             stop
            endif

            call gridav(climu,idim,jdim,deg,globu)
            call gridav(climv,idim,jdim,deg,globv)
            print *,iyrc,imthc,idayc,icyc,ifhr,globu,globv

           enddo

           call baclose(71,ierr)
           if(ierr.ne.0) then
            print *,'error closing file ',clmfile
            stop
           endif
c
          endif

         enddo
c
c* Huug's original way:
c      do ncn=ncns,ncne ! (Julian days range, all 6 years) initial times
c       call w3fs26(ncn,iyr,imth,iday,idaywk,idayyr)
c       if (iday.eq.1)then
c        lead=0
c        do id=1,nfdys
c         lead0=lead
c         lead=lead+1! 0Z
c         lead0=lead
c         call recoclimo(annmean,a,b,lead,clim,idim,jdim,ncn,nfdys)
c         x1=clim(600,288)
c* write out clim, the target 0Z clim for that IC and lead
c         lead=lead+1! 6Z
c         call recoclimo(annmean,a,b,lead,clim,idim,jdim,ncn,nfdys)
c         x2=clim(600,288)
c* write out clim, the target 6Z clim for that IC and lead
c         lead=lead+1! 12Z
c         call recoclimo(annmean,a,b,lead,clim,idim,jdim,ncn,nfdys)
c         x3=clim(600,288)
c* write out clim, the target 12Z clim for that IC and lead
c         lead=lead+1! 18Z
c         call recoclimo(annmean,a,b,lead,clim,idim,jdim,ncn,nfdys)
c         x4=clim(600,288)
c* write out clim, the target 18Z clim for that IC and lead
c         print 411,iyr,imth,iday,lead0,lead,x1,x2,x3,x4
c        enddo
c       endif 
c      enddo
c411   format(5i6,4f8.2)

       print*,"I AM DONE in mkclimn"
       return
       end
c
      subroutine recoclimo(annmean,a,b,lead,clim,idim,jdim,ncn,nfdys)
      real clim(idim,jdim),annmean(idim,jdim,nfdys*4)
       real a(idim,jdim,nfdys*4,4),b(idim,jdim,nfdys*4,4)
      nd=ncn-2455653+1! we take apr 1 2011 as nd=1. 
       PI=4.*ATAN(1.)
       period=365.24219
       OMEGA=2.0*PI/period
       clim(:,:)=annmean(:,:,lead)
       do itone=1,4
       ANGLE = FLOAT(nd) * OMEGA*float(itone)
       FAKC = COS(ANGLE)
       FAKs = SIN(ANGLE)
       clim(:,:)=clim(:,:)
     *   +a(:,:,lead,itone)*faks+b(:,:,lead,itone)*fakc
       enddo
c
      return
      end
